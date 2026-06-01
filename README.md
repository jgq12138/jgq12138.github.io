# jgq12138.github.io

JGQ12138 的个人博客，基于 [Hexo](https://hexo.io/) 构建，使用 [Fluid](https://github.com/fluid-dev/hexo-theme-fluid) 主题，部署在 GitHub Pages。

## 常用命令

```bash
npm run build    # 生成静态文件 (hexo generate)
npm run server   # 启动本地预览 (hexo server)
npm run clean    # 清除缓存 (hexo clean)
npm run deploy   # 手动部署到 gh-pages
npx hexo new "标题"        # 新建文章
npx hexo new page "名称"   # 新建页面
```

## 自动部署

推送到 `main` 分支会自动触发 GitHub Actions 构建并部署到 GitHub Pages。
