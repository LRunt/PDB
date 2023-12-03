import laspy
import pylas

import numpy as np
import pylas as pylas
from scipy.spatial import Delaunay

if __name__ == "__main__":
    with pylas.open('data/AS01/AS01.laz') as fh:
        print('Points from Header:', fh.header.point_count)
        las = fh.read()
        print(las)
        print('Points from data:', len(las.points))
        ground_pts = las.classification == 2
        bins, counts = np.unique(las.return_number[ground_pts], return_counts=True)
        print('Ground Point Return Number distribution:')
        for r,c in zip(bins,counts):
            print('    {}:{}'.format(r,c))

