import os

sku_num = "410"

path = "/Users/cgarcia/Desktop/{}".format(sku_num)

for root, dirs, files in os.walk(path):
    for file in files:
        if sku_num in file:
            os.rename(os.path.join(root, file), os.path.join("/_Source/{0}/{0}_mus".format(sku_num), file))
