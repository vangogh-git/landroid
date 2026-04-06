import json
from pyproj import Transformer

with open('assets/boundary.geojson') as f:
    data = json.load(f)

transformer = Transformer.from_crs("EPSG:32644", "EPSG:4326", always_xy=True)

coords = data['features'][0]['geometry']['coordinates']

new_coords = []
for c in coords:
    lon, lat = transformer.transform(c[0], c[1])
    new_coords.append([lon, lat])

data['features'][0]['geometry']['coordinates'] = new_coords

with open('assets/boundary_wgs84.geojson', 'w') as f:
    json.dump(data, f)

print("Sample coord:", new_coords[0])
print("Total points:", len(new_coords))