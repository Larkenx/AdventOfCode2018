$input = Get-Content -Path ".\input.txt"
# function Get-Manhattan-Distance {
#     param([int]$x1, [int]$y1, [int]$x2, [int]$y2)
#     $xpart = $x1 - $x2
#     if ($xpart -lt 0) {
#         $xpart *= -1
#     }
#     $ypart = $y1 - $y2
#     if ($ypart -lt 0) {
#         $ypart *= - 1
#     }
#     return $xpart + $ypart
# }

# From https://ss64.com/ps/syntax-base36.html
function convertTo-Base36 {
    param ([int]$decNum)
    $alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
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


$points = @()
$pointIdentifier = 0
foreach ($line in $input) {
    $parts = $line -split ", " 
    $id = convertTo-Base36 $pointIdentifier
    $points += , ([int]$parts[0], [int]$parts[1], $id)
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

$histogram = @{}
$infinite = @{}
for ($y = $starty; $y -lt $height + 1; $y++) {
    for ($x = $startx; $x -lt $width + 1; $x++) {
        $minDistance = [int]::MaxValue
        $tied = $false
        $pointIdentifier = ""
        foreach ($point in $points) {
            $xpart = $x1 - $x2
            if ($xpart -lt 0) {
                $xpart *= -1
            }
            $ypart = $y1 - $y2
            if ($ypart -lt 0) {
                $ypart *= - 1
            }
            $dist = $xpart + $ypart 
            if ($dist -eq $minDistance) {
                $tied = $true
            }
            
            if ($dist -lt $minDistance) {
                $minDistance = $dist
                $pointIdentifier = $point[2]
                $tied = $false
            }
        }

        if (($y -eq $starty) -or ($x -eq $startx) -or ($x -eq $width) -or ($y -eq $height)) {
            if (!$infinite.ContainsKey($pointIdentifier)) {
                $infinite.Add($pointIdentifier, $true)
            }
        }

        if (!($tied)) {
            if (!($histogram.ContainsKey($pointIdentifier))) {
                $histogram.Add($pointIdentifier, 0)
            }
            $histogram[$pointIdentifier]++
        }
    }
}

$biggestSpace = 0
$histogram.GetEnumerator() | ForEach-Object {
    $message = '{0} covers {1} squares!' -f $_.key, $_.value
    Write-Output $message
    if ($_.value -gt $biggestSpace -and !($infinite.ContainsKey($_.key)) ) {
        $biggestSpace = $_.value
    }
} 
Write-Output $biggestSpace

