## 背景
多人维护的工程相同的图片资源会被改成不同的名称拖入工程中，模块化开发的重复图片会更多。
## 功能
找出工程中重复图片，减小APP包的大小。
## 实现
算出每张图片的md5值，通过md5值判断图片是否相同。



