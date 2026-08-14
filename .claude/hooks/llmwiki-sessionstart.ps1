# llmwiki SessionStart 훅 — 재검토 시점이 도래한 보류 안건을 세션 시작 때 컨텍스트로 주입
# docs/pending.md의 표에서 ISO 날짜(YYYY-MM-DD)가 오늘 이하인 행을 찾는다.
# 조건형(날짜 없는) 안건은 여기서 잡지 않는다 — lint가 점검한다.
# 한글 출력이 깨지지 않도록 stdout을 UTF-8로 고정 (파일 자체도 UTF-8 BOM으로 저장할 것)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$pending = "docs/pending.md"
if (-not (Test-Path $pending)) { exit 0 }

$today = Get-Date -Format 'yyyy-MM-dd'
$due = Get-Content $pending -Encoding UTF8 | Where-Object {
    $_ -match '\|' -and $_ -match '(\d{4}-\d{2}-\d{2})' -and $matches[1] -le $today
}

if ($due) {
    Write-Output "[llmwiki] 재검토 시점이 도래한 보류 안건이 있다:"
    $due | ForEach-Object { Write-Output $_ }
    Write-Output "사용자에게 이 안건의 재검토 미팅 시작을 제안하라. 재검토가 끝나면 pending.md에서 해당 행을 결정 페이지로 옮긴다."
}
exit 0
