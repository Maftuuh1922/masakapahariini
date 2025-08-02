# Script untuk menerima semua lisensi Android SDK
$sdkmanager = "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat"

# Buat input file dengan jawaban 'y' berulang
$yesInput = ""
for ($i = 1; $i -le 20; $i++) {
    $yesInput += "y`n"
}

# Tulis ke temporary file
$inputFile = "$env:TEMP\license_input.txt"
$yesInput | Out-File -FilePath $inputFile -Encoding ASCII

# Jalankan sdkmanager dengan input file
Get-Content $inputFile | & $sdkmanager --licenses

# Hapus temporary file
Remove-Item $inputFile -ErrorAction SilentlyContinue
