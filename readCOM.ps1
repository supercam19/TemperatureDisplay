# You might need to change these!
# If you're unsure which port, check the Arduino IDE for which one it is connected to.
# Baud rate can stay the same unless you changed it in the Arduino script
$portName = "COM3"
$baudRate = 9600


$port = new-Object System.IO.Ports.SerialPort $portName,$baudRate,None,8,one

$isAvailible = $false
try {
    $port.Open()
    $isAvailible = $true
}
catch {
    $isAvailible = $false
}

$failed = $false
$global:reading = "-"
$global:lastStable = "-"
function Update {
    if (!$failed) {
        if ($isAvailible) {
            # Cannot use ReadLine() without making this script Async because Rainmeter will crash if the thread is blocked too long
            # Even at a high polling rate it is unstable to use ReadLine() on the same thread
            $data = $port.ReadExisting().Split("\n")
            $global:reading = $data[$data.Length - 1]
            # Occasionally temperature reading will return empty string
            if (!$global:reading.Split(",")[0] -eq "") {
                $global:lastStable = $global:reading.Split(",")[0]
            }
            $global:lastStable
        }
        else {
            Write-Warning "Error: Could not open $portName (maybe it's being used by something else)"
            $failed = $true
            echo "ERR"
        }
    }
}

# Read immediately instead of waiting 1 sec
Update
function Finalize {
    if ($isAvailible) {
        $port.Dispose()
    }
}