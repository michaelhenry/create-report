# create-report

[![codecov](https://codecov.io/gh/michaelhenry/create-report/branch/main/graph/badge.svg?token=TC3XYJYG61)](https://codecov.io/gh/michaelhenry/create-report)
[![codebeat badge](https://codebeat.co/badges/f52c2068-17ca-41a1-8421-f6b54e4155d4)](https://codebeat.co/projects/github-com-michaelhenry-create-report-main) [![Test Coverage](https://api.codeclimate.com/v1/badges/20de4a63612d960d1bf1/test_coverage)](https://codeclimate.com/github/michaelhenry/create-report/test_coverage) [![Maintainability](https://api.codeclimate.com/v1/badges/20de4a63612d960d1bf1/maintainability)](https://codeclimate.com/github/michaelhenry/create-report/maintainability)

A Github action for creating generic run report. Currently this action is supporting 3 data format: `markdown`, `html` or `junit`.

Sample workflow:
```yml
jobs:
  create-report:
    name: Report using ${{ matrix.os }}
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses:  ./
      name: create report from a junit file.
      with:
        title: "JUnit report"
        path: samples/sample.junit
        format: junit
```

## Using Markdown

```yml
  - uses: michaelhenry/create-report@v2.0.0
    name: create report from markdown
    with:
      title: "Markdown report"
      path: samples/sample.md
      format: markdown
```

Please see [samples/sample.md](samples/sample.md) for the sample file which generated this run report.

<img width="801" alt="Screen Shot 2022-04-10 at 23 28 09" src="https://user-images.githubusercontent.com/717992/162620495-998b0195-3f49-4e9c-892c-fc0a4be9af6b.png">

---

## Using HTML

```yml
  - uses: michaelhenry/create-report@v2.0.0
    name: create report from html
    with:
      title: "HTML report"
      path: samples/sample.html
      format: html
```

Please see [samples/sample.html](samples/sample.html) for the sample file which generated this run report.

<img width="945" alt="Screen Shot 2022-04-10 at 23 27 32" src="https://user-images.githubusercontent.com/717992/162620514-b76f11fb-4ba7-4d43-a202-043d360cffd7.png">

---

## Using JUnit

```yml
  - uses: michaelhenry/create-report@v2.0.0
    name: create report from junit
    with:
      title: "JUnit report"
      path: samples/sample.junit
      format: junit
```

Please see [samples/sample.junit](samples/sample.junit) for the sample file which generated this run report.

<img width="924" alt="Screen Shot 2022-04-10 at 23 26 19" src="https://user-images.githubusercontent.com/717992/162620429-f2b006a1-b4bd-486d-95fb-44d827b058bb.png">

---
