Add-Type -AssemblyName System.speech

$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Speak("BioMed Sucks, Jordan is the new Scooter")