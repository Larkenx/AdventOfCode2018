$input = Get-Content -Path ".\input.txt"
function Get-Manhattan-Distance {
    param([int]$x1, [int]$y1, [int]$x2, [int]$y2)
    [math].GetMethods() | Select -Property Name -Unique| Out-Null
    $result = [math]::Abs($x1 - $x2) + [math]::Abs($y1 - $y2) 
    return $result
}

# From https://ss64.com/ps/syntax-base36.html
function convertTo-Base36 {
    param ([int]$decNum)
    $alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    do {
        $remainder = ($decNum % 62)
        $char = $alphabet.substring($remainder, 1)
        $base36Num = "$char$base36Num"
        $decNum = ($decNum - $remainder) / 62
    }
    while ($decNum -gt 0)

    $base36Num
    # $base64Num = [System.Convert]::ToBase64String($decNum) 
    # $base64Num
}


$points = New-Object System.Collections.ArrayList
$pointIdentifier = 0
foreach ($line in $input) {
    $parts = $line -split ", " 
    $id = convertTo-Base36 $pointIdentifier
    $points.Add(@([int]$parts[0], [int]$parts[1], $id))
    $pointIdentifier++
}

$p = $points[0]
# By default the first point is the farthest left/up/down/right
$startx = $p[0] 
$starty = $p[1]
$width = $p[0]
$height = $p[1]
foreach ($point in $points) {
    if ($point[0] -lt $startx) {
        $startx = $point[0]
    }
    if ($point[1] -lt $starty) {
        $starty = $point[1]
    }
    if ($point[0] -gt $width) {
        $width = $point[0]
    }
    if ($point[1] -gt $height) {
        $height = $point[1]
    }
}

$map = New-Object System.Collections.ArrayList
$histogram = @{}
$yIndex = 0
for ($y = $starty; $y -lt $height; $y++) {
    $row = New-Object System.Collections.ArrayList
    $map.Add($row)
    for ($x = $startx; $x -lt $width; $x++) {
        $minDistance = [int]::MaxValue
        $tied = $false
        $pointIdentifier = ""
        foreach ($point in $points) {
            $dist = Get-Manhattan-Distance $x $y $point[0] $point[1] 
            if ($dist -eq $minDistance) {
                $tied = $true
                break
            }
            elseif ($dist -lt $minDistance) {
                $minDistance = $dist
                $pointIdentifier = $point[2]
            }
        }
        if ($tied) {
            $map[$yIndex].Add(".") 
        }
        else {
            $map[$yIndex].Add($pointIdentifier)
            if (!$histogram.ContainsKey($pointIdentifier)) {
                $histogram.Add($pointIdentifier, 0)
            }
            $histogram[$pointIdentifier]++
        }
    }
    $yIndex++
}

$histogram.GetEnumerator() | ForEach-Object {
    $message = '{0} covers {1} squares!' -f $_.key, $_.value
    Write-Output $message
} 
Write-Output $map

