# Create Report

A Github action for creating generic run report (using Markdown!)

```yml
- uses:  michaelhenry/create-report@1.0.0
  with:
  repository: ${username}/${repo-name}
  github-token: ${{ secrets.GITHUB_TOKEN }}
  report-name: "Sample report"
  report-summary: "# HELLO WORLD \n > Your markdown text"
```
<img width="1076" alt="Screen Shot 2021-12-13 at 4 06 32" src="https://user-images.githubusercontent.com/717992/145722614-bc2987a6-72b3-4f26-9948-6bcf40658854.png">
