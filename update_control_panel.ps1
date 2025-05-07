$controlPanelCss = @'
<link rel="stylesheet" href="css/control-panel.css" />
'@

$newSidebar = @'
<div id="sidebarMenu" class="fixed top-0 left-0 h-full w-64 bg-white shadow-lg transform -translate-x-full transition-transform duration-300">
    <div class="p-4 bg-blue-500 text-white flex justify-between items-center">
        <h2 class="text-lg font-bold">Control Panel</h2>
        <button id="closeButton" class="text-xl">&times;</button>
    </div>
    <nav class="p-4">
        <a href="index.html" class="block px-4 py-2 text-gray-700 hover:bg-gray-200 rounded">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/>
                <path d="M9 22V12h6v10"/>
            </svg>
            Homepage
        </a>
        <a href="html-branch-3/earthscilesson/quizzes.html" class="block px-4 py-2 text-gray-700 hover:bg-gray-200 rounded">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
            </svg>
            Quizzes
        </a>
        <a href="misc/comingsoon.html" class="block px-4 py-2 text-gray-700 hover:bg-gray-200 rounded">
            <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
            </svg>
            Modules
        </a>
        <hr class="my-4 border-gray-700">
    </nav>
</div>
'@

Get-ChildItem -Path . -Filter "*.html" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    # Add control panel CSS if not present
    if (-not $content.Contains("control-panel.css")) {
        $content = $content.Replace(
            '<link rel="stylesheet" href="css/',
            '<link rel="stylesheet" href="css/control-panel.css" />' + "`n    " + '<link rel="stylesheet" href="css/'
        )
    }
    
    # Update sidebar menu
    $content = $content -replace '<div id="sidebarMenu"[^>]*>.*?</div>\s*</div>', $newSidebar
    
    # Add the JavaScript for menu functionality if not present
    if (-not $content.Contains("menuButton.addEventListener")) {
        $menuScript = @'
    <script>
        const menuButton = document.getElementById("menuButton");
        const menuIcon = document.getElementById("menuIcon");
        const sidebarMenu = document.getElementById("sidebarMenu");
        const closeButton = document.getElementById("closeButton");

        menuButton.addEventListener("click", function () {
            sidebarMenu.classList.toggle("-translate-x-full");
            menuIcon.classList.toggle("rotate-90");
        });

        closeButton.addEventListener("click", function () {
            sidebarMenu.classList.add("-translate-x-full");
            menuIcon.classList.remove("rotate-90");
        });

        // Close menu when clicking outside
        document.addEventListener("click", function (event) {
            if (!sidebarMenu.contains(event.target) && !menuButton.contains(event.target)) {
                sidebarMenu.classList.add("-translate-x-full");
                menuIcon.classList.remove("rotate-90");
            }
        });
    </script>
'@
        $content = $content -replace '</body>', "$menuScript`n</body>"
    }
    
    Set-Content -Path $_.FullName -Value $content -Encoding UTF8
    Write-Host "Updated $($_.FullName)"
} 