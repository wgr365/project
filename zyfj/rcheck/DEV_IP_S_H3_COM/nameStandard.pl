#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_nameStandard ############
# �ļ�����: Ѳ��ģ�庯��
# ��������: ��ΪBAS M9000 �����淶 
# ��    ��: wanggr 2015-7-20
# �޸�����, �޸���,����id/bugid,��ϸ����ĵ���,����
#################################################
#>display current-configuration | include sysname
#sysname ND-FA-SQ-BAS-1.MAN.ME60
# sysname ND-FA-SQ-BAS-1.MAN.MA5200G
#�쳣���豸���ƣ�xx-xx-xx-BAS-#.MAN.xx    ��������: xx-xx-xx-BAS-#.MAN.xx
my $CheckLog;
my ($sValue,$mValue,$maxValue,$errnum) = (-1,-0.5,-10,0);
my ($result,$label,$errFlag,$iii,$mydevname,$myhostname)=("S",0,0,0,"","");
my $sql = "select DEVICENAME from device d where d.deviceid='$resID' and d.changetype = 0";
my @result = cmd_sql($sql);
foreach (@result){
	$mydevname = $_->{'DEVICENAME'};
}
print "��������:$mydevname\n";
exec_cmd('display current-configuration | i sysname');
if ($CMD_ERROR ne ''){
  $TMP_RESULT="����ִ�д���: $CMD_ERROR";
  return -1;
}
foreach(@RESULT){
  $CheckLog .= "<strong>$_</strong>\n" if($iii==0);
  if($iii>0){
  	if($_=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i){
  		$CheckLog .= "<font color='red'>$_</font>\n";
		  $errnum +=2;
		  $errFlag = 6;
		  $result = "E";
		  last;
  	}elsif($_ =~/^\s*sysname\s+(\S+)/i){
  		$myhostname = $1;
  		print "�豸����:$myhostname\n";
  		if($myhostname ne $mydevname){
  			$CheckLog .= "<font color='red'>$_</font>\n";
  		  $errnum +=1;
		    $errFlag = 1;
		    $result = "E";
		  }else{
		  	$CheckLog .= "$_\n";
		  }
  	}elsif($label){
  		$CheckLog .= "$_\n";
  	}
  }
  $iii++;
}

my $scoreValue = $errnum? $sValue + ($errnum-1)*$mValue:0;
$scoreValue = $maxValue if($scoreValue<$maxValue && $maxValue != 0);

$CheckLog .= "��������:$mydevname\n" ;

$CheckLog .= "<font color='red'>�쳣���豸����:$myhostname  ��������:$mydevname��</font>\n" if($errFlag!=6 && $errFlag);
$CheckLog .= "<font color='red'>��������������Ȩ�޲���</font>\n" if($errFlag==6);
$CheckLog .= "<font color='blue'>�ж�����:�豸�����Ƿ��������һ�£���һ����澯��</font>\n";
logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1;

