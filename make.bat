@echo off
REM ============================================================
REM MkDocs 构建脚本 (Windows)
REM 用法: make.bat <command>
REM ============================================================

if "%1" == "" goto help
if "%1" == "html" goto html
if "%1" == "serve" goto serve
if "%1" == "clean" goto clean
if "%1" == "deploy" goto deploy
goto help

:html
echo [构建] 正在生成 HTML 静态文件...
mkdocs build
echo [完成] HTML 文件已输出到 docs\ 目录
goto end

:serve
echo [启动] 正在启动本地预览服务器...
echo [提示] 浏览器打开 http://127.0.0.1:8000/ 查看
echo [提示] 按 Ctrl+C 停止
mkdocs serve
goto end

:clean
echo [清理] 正在删除 docs\ 目录...
if exist docs rmdir /s /q docs
echo [完成] 已清理
goto end

:deploy
echo [部署] 正在部署到 GitHub Pages...
mkdocs gh-deploy
echo [完成] 部署完毕
goto end

:help
echo ============================================================
echo  MkDocs 构建脚本用法: make.bat ^<command^>
echo ============================================================
echo.
echo  可用命令:
echo    serve    启动本地实时预览服务器 (开发用, 支持热重载)
echo    html     生成 HTML 静态文件到 docs\ 目录
echo    clean    删除 docs\ 目录 (清理构建产物)
echo    deploy   部署到 GitHub Pages
echo.
echo  示例:
echo    make.bat serve
echo    make.bat html
echo ============================================================
goto end

:end
