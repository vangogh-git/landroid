"""
Reproject boundary.geojson from UTM projected meters to WGS84 (EPSG:4326).
Reads assets/Boundary.geojson, writes assets/boundary_wgs84.geojson.
"""

import json
import math
import os

try:
    from pyproj import Transformer
except ImportError:
    print("pyproj not installed. Run: pip install pyproj shapely")
    exit(1)

INPUT = os.path.join("assets", "Boundary.geojson")
OUTPUT = os.path.join("assets", "boundary_wgs84.geojson")


def detect_utm_zone(easting, northing):
    """Detect UTM zone from coordinate values."""
    zone = int(math.floor((easting / 600000) + 31))
    zone = max(1, min(60, zone))
    hemisphere = "north" if northing > 0 else "south"
    epsg = 32600 + zone if hemisphere == "north" else 32700 + zone
    return zone, hemisphere, epsg


def main():
    with open(INPUT, "r") as f:
        data = json.load(f)

    # Get first coordinate to detect zone
    if data["type"] == "FeatureCollection":
        geom = data["features"][0]["geometry"]
    elif data["type"] == "Feature":
        geom = data["geometry"]
    else:
        geom = data

    coords = geom["coordinates"]
    if geom["type"] == "LineString":
        first = coords[0]
    elif geom["type"] == "Polygon":
        first = coords[0][0]
    else:
        first = coords[0][0][0]

    easting, northing = float(first[0]), float(first[1])

    # Try CRS from geojson first, fallback to auto-detect
    crs_props = data.get("crs", {})
    src_epsg = None
    if crs_props:
        name = crs_props.get("properties", {}).get("name", "")
        if "EPSG" in name:
            src_epsg = int(name.split("::")[-1])

    if src_epsg is None or src_epsg == 4326:
        zone, hem, src_epsg = detect_utm_zone(easting, northing)
        print(f"Auto-detected: UTM Zone {zone}{hem[0].upper()} (EPSG:{src_epsg})")
    else:
        zone = src_epsg - 32600
        print(f"Using CRS from file: EPSG:{src_epsg} (UTM Zone {zone}N)")

    transformer = Transformer.from_crs(f"EPSG:{src_epsg}", "EPSG:4326", always_xy=True)

    def reproject_coord(c):
        lon, lat = transformer.transform(float(c[0]), float(c[1]))
        return [lon, lat] + c[2:]

    def reproject_coords_list(coords_list):
        return [reproject_coord(c) for c in coords_list]

    geom_type = geom["type"]
    if geom_type == "LineString":
        new_coords = reproject_coords_list(coords)
    elif geom_type == "Polygon":
        new_coords = [reproject_coords_list(ring) for ring in coords]
    elif geom_type == "MultiLineString":
        new_coords = [reproject_coords_list(ring) for ring in coords]
    elif geom_type == "MultiPolygon":
        new_coords = [[reproject_coords_list(ring) for ring in poly] for poly in coords]
    else:
        raise ValueError(f"Unsupported geometry: {geom_type}")

    # Build output
    output = {
        "type": "FeatureCollection",
        "crs": {"type": "name", "properties": {"name": "urn:ogc:def:crs:EPSG::4326"}},
        "features": [{
            "type": "Feature",
            "properties": geom.get("properties", data.get("features", [{}])[0].get("properties", {})),
            "geometry": {"type": geom_type, "coordinates": new_coords},
        }],
    }

    with open(OUTPUT, "w") as f:
        json.dump(output, f, indent=2)

    first_reprojected = new_coords[0] if isinstance(new_coords[0], list) and isinstance(new_coords[0][0], (int, float)) else new_coords[0][0]
    print(f"\nFirst reprojected coordinate: ({first_reprojected[0]:.6f}, {first_reprojected[1]:.6f})")
    print(f"Output written to: {OUTPUT}")

    # Compute centroid for .env update
    lats = []
    lons = []
    flat = new_coords if geom_type == "LineString" else new_coords[0]
    for c in flat:
        lons.append(c[0])
        lats.append(c[1])
    centroid_lat = sum(lats) / len(lats)
    centroid_lon = sum(lons) / len(lons)
    print(f"\nCentroid: ({centroid_lat:.6f}, {centroid_lon:.6f})")
    print(f"Bounding box: min_lon={min(lons):.6f}, min_lat={min(lats):.6f}, max_lon={max(lons):.6f}, max_lat={max(lats):.6f}")
    print(f"\nUpdate .env with:")
    print(f"  CENTROID_LAT={centroid_lat:.6f}")
    print(f"  CENTROID_LNG={centroid_lon:.6f}")
    print(f"  BBOX_MIN_LON={min(lons):.6f}")
    print(f"  BBOX_MIN_LAT={min(lats):.6f}")
    print(f"  BBOX_MAX_LON={max(lons):.6f}")
    print(f"  BBOX_MAX_LAT={max(lats):.6f}")


if __name__ == "__main__":
    main()
