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
