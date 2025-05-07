import os
import re

def update_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Add the control panel CSS link if it doesn't exist
    if 'control-panel.css' not in content:
        content = content.replace(
            '<link rel="stylesheet" href="css/stylesheet.css" />',
            '<link rel="stylesheet" href="css/stylesheet.css" />\n    <link rel="stylesheet" href="css/control-panel.css" />'
        )

    # Update the sidebar menu structure
    sidebar_pattern = r'<div id="sidebarMenu"[^>]*>.*?</div>\s*</div>'
    new_sidebar = '''<div id="sidebarMenu" class="fixed top-0 left-0 h-full w-64 bg-white shadow-lg transform -translate-x-full transition-transform duration-300">
        <div class="p-4 bg-blue-500 text-white flex justify-between items-center">
            <h2 class="text-lg font-bold">Control Panel</h2>
            <button id="closeButton" class="text-xl">&times;</button>
        </div>
        <nav class="p-4">
            <a href="misc/about.html" class="block px-4 py-2 text-gray-700 hover:bg-gray-200 rounded">
                <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z"/>
                </svg>
                About the researchers
            </a>
            <a href="misc/feedback.html" class="block px-4 py-2 text-gray-700 hover:bg-gray-200 rounded">
                <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z"/>
                </svg>
                Provide feedback!
            </a>
            <hr class="my-4 border-gray-700">
        </nav>
    </div>'''

    content = re.sub(sidebar_pattern, new_sidebar, content, flags=re.DOTALL)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def process_directory(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.html'):
                file_path = os.path.join(root, file)
                try:
                    update_file(file_path)
                    print(f"Updated {file_path}")
                except Exception as e:
                    print(f"Error updating {file_path}: {str(e)}")

if __name__ == "__main__":
    process_directory('.') 