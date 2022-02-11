# RDP connect automation
# <requirements>
# Default.rdp 파일 내 enablecredsspsupport:i:1 으로 셋팅 (위치: mstsc실행해서 다른이름으로 저장->해당 경로에 숨김파일)

# CSV파일 위치
$list = Import-Csv "D:\python\VMware\mstsc.csv"

<#
$Server="165.246.3.12"
$User="cicinha"
$Password="INHA@cic10"
$Port="10009"
#>

foreach ($cols in $list) {
    #RDP 접속서버 정보
    $Server = $cols.Server                  #서버 IP(defualt port가 아니더라도 IP만 작성)
    $User = $cols.User                      #RDP login ID
    $Password = $cols.Password              #RDP login 패스워드
    $Port = $cols.Port                      #PORT

    # Windows 자격증명에 해당 서버에 대한 계정정보를 저장. 저장하면 RDP 접속 시 자동으로 로그인 됨 (위치: 제어판->사용자 계정->자격 증명 관리자)
    cmdkey /generic:$Server /user:$User /pass:$Password

    # RDP접속
    mstsc /v:$Server":"$Port
}

foreach ($cols in $list) {Write-Host "Connected to "$Server}

# 자격증명은 보안상 로그인 후 PC에서 삭제. 바로 삭제할경우 RDP 자동로그인이 되지 않으므로 사용자 확인 후에 삭제
$confirmation = Read-Host "Are you Sure You Want To Proceed:"
if ($confirmation -eq 'y') {
    cmdkey /delete:$Server
}