import os

# 指定文件夹路径
folder_path = './smoke'

# 获取文件夹中所有文件名
file_names = os.listdir(folder_path)

# 初始化索引
index = 1

# 循环重命名文件
for filename in file_names:
    # 获取文件的完整路径
    old_path = os.path.join(folder_path, filename)

    # 生成新的文件名
    new_filename = f"{index}.jpg"

    # 获取新的完整路径
    new_path = os.path.join(folder_path, new_filename)

    # 重命名文件
    os.rename(old_path, new_path)

    # 更新索引
    index += 1
