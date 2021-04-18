from shutil import copyfile
import os

for root, file in os.walk("/Users/cgarcia/Desktop/420"):
    print(os.path(root+file))

# copyfile(src, dst)