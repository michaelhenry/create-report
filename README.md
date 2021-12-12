# Create Report

A Github action for creating generic run report

```xml
    - uses:  michaelhenry/create-report@1.0.0
      with:
        repo: create-report
        owner: michaelhenry
        github-token: ${{ secrets.GITHUB_TOKEN }}
        report-name: "Sample report"
        report-summary: "# HELLO WORLD \n > Your markdown text"
```