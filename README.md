# jgq12138.github.io

Jgq12138 blog

## Hexo是一个基于Node.js的静态博客框架，用于快速搭建个人博客。以下是一些常见的Hexo命令参数：

- 1. hexo init [folder]：初始化一个新的Hexo博客，[folder]为可选参数，指定博客的文件夹名称。
- 2. hexo new [title]：创建一篇新的文章，[title]为文章的标题。
- 3. hexo generate：生成静态网页，将Markdown文件转换为HTML文件。
- 4. hexo server：启动本地服务器，用于预览博客网页。
- 5. hexo deploy：部署博客到远程服务器，如GitHub Pages。
- 6. hexo clean：清除Hexo生成的缓存文件。
- 7. hexo help：显示Hexo的帮助信息，列出所有可用的命令和参数。
- 8. hexo version：显示Hexo的版本信息。

## build

```bash
npm install -g hexo-cli
npm install hexo-deployer-git --save
hexo clean
hexo generate
hexo deploy
```

## 安装主题

```bash
git submodule add https://github.com/cofess/hexo-theme-pure.git themes/pure
```
