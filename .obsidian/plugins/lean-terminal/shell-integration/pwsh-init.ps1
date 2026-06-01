# Lean Terminal - shell integration for PowerShell
if ($env:__LOT_SHELL_INTEGRATION) { return }
$env:__LOT_SHELL_INTEGRATION = "1"
$__lot_original_prompt = $function:prompt
function prompt {
    $ec = $global:LASTEXITCODE
    [Console]::Out.Write("`e]133;D;$ec`e\")
    [Console]::Out.Write("`e]133;A`e\")
    $result = & $__lot_original_prompt
    [Console]::Out.Write("`e]133;B`e\")
    return $result
}
[Console]::Out.Write("`e]133;A`e\")