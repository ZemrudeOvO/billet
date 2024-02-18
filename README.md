一个简单的记帐软件

# How to use

1. cd %YOUR APP DIR%
2. ./billet

# FIX
- [ ] strcov/decimal
- [ ] 数据排序修改为两位小数
- [ ] f64造成精度损失，将f64改为int存储数据
- [ ] 删除收入和支出数值前的正负号
- [ ] 当数据中收入或支出的个数为0时，会数组越界

# TODO
- [ ] 修改所有中文项目为英语
- [ ] 配置文件（使用反射）
- [ ] 通过反射offset指针修改同名结构体变量的值
- [ ] 配置中可设置当前目录下的data文件
- [ ] 当不存在文件时可新建data文件
- [ ] 日期加上快捷的“今天”和“昨天”
- [ ] 获取最近一次数据录入内容
- [ ] 将data.blt存储到~/billet/文件夹中（如不存在则新建），将相对路径转为绝对路径
- [ ] os.open
- [ ] 将data.blt单独push到GitHub上，将billet的repo中的data.blt删除
