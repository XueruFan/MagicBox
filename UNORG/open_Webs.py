# -*- coding: utf-8 -*-
import webbrowser
import time

# 网站URL前缀
base_url = "http://159.226.113.251:9025/fmriprep/RS0001-"

# 开始和结束的数字序列
start_num = 876
end_num = 900

# 遍历数字序列，生成并打开URL
for i in range(start_num, end_num + 1):
    # 生成完整的URL
    url = f"{base_url}{i:04}.html"
    # 打开网页
    webbrowser.open_new_tab(url)
    # 这里设置一个短暂的延迟，以避免同时打开太多标签
    time.sleep(0.5)  # 暂停0.5秒
