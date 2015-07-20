#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_nameStandard ############
# 文件类型: 巡检模板函数
# 基本功能: 华为BAS M9000 命名规范 
# 编    者: wanggr 2015-7-20
# 修改日期, 修改人,任务id/bugid,详细设计文档名,描述
#################################################
#>display current-configuration | include sysname
#sysname ND-FA-SQ-BAS-1.MAN.ME60
# sysname ND-FA-SQ-BAS-1.MAN.MA5200G
#异常：设备名称：xx-xx-xx-BAS-#.MAN.xx    网管名称: xx-xx-xx-BAS-#.MAN.xx
my $CheckLog;
my ($sValue,$mValue,$maxValue,$errnum) = (-1,-0.5,-10,0);
my ($result,$label,$errFlag,$iii,$mydevname,$myhostname)=("S",0,0,0,"","");
my $sql = "select DEVICENAME from device d where d.deviceid='$resID' and d.changetype = 0";
my @result = cmd_sql($sql);
foreach (@result){
	$mydevname = $_->{'DEVICENAME'};
}
print "网管名称:$mydevname\n";
exec_cmd('display current-configuration | i sysname');
if ($CMD_ERROR ne ''){
  $TMP_RESULT="命令执行错误: $CMD_ERROR";
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
  		print "设备名称:$myhostname\n";
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

$CheckLog .= "网管名称:$mydevname\n" ;

$CheckLog .= "<font color='red'>异常：设备名称:$myhostname  网管名称:$mydevname。</font>\n" if($errFlag!=6 && $errFlag);
$CheckLog .= "<font color='red'>命令错误或者命令权限不足</font>\n" if($errFlag==6);
$CheckLog .= "<font color='blue'>判断条件:设备名称是否和网管上一致，不一致则告警。</font>\n";
logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1;

