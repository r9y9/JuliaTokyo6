using PCLCommon,PCLIO,PCLVisualization

# 点群データの読み込み
cloud = PointCloud{PointXYZRGBA}(Pkg.dir("PCL","test","kumamon","kumamon.pcd"));

# Viewer の準備
viewer = PCLVisualizer("test");

# Viewr に点群を追加
addPointCloud(viewer, cloud, id="input")

# Render
spin(viewer)

# 後始末
close(viewer);viewer=0;gc()
