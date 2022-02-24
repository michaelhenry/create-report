import sys
from markdownify import markdownify as md
html = ""
for line in sys.stdin:
    html += line
print(md(html))
