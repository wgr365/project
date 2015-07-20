#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_TimeSync ############
# 文件类型: 巡检模板函数
# 基本功能: M9000  时钟同步巡检项目
# 修改日期, 修改人,任务id/bugid,详细设计文档名,描述
# 20150717  wangguorong   增加判断条件，按设备属性单独出NE40―X16路由器
#################################################

my $DevType='';
my $CheckLog='';
my $errnum;
my $errFlag;
my $result='S';
my $sValue;
my $mValue;
my $maxValue;
my $status='';
my $cur_port='';
my @line_array;
my @line_array2;


my @port;
my @tmp1Array;
my @tmp2Array;




my $iii=0;
my $iii_cnt=0;
my $next_iii=0;
my $SlotNo=100;
my $CPUNo=100;
my $CurrentSessions=0;
my $SessionEstablishmentRate=0;
my $TotalDynamicPort=0;
my $ActiveDynamicPort=0;
my $ClockStatus;

my $errorTrunks;

exec_cmd('');
$DevType = $RESULT[$#RESULT];
print "******DevType:$DevType \n";

#step 1 dis ntp-service status , Clock status 为synchronized正常，否则异常
exec_cmd('dis ntp-service status');  

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="命令执行错误: $CMD_ERROR";
  return -1;
}
$iii=0;
foreach my $line (@RESULT) #取出目标行
{
	if($line=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i)      #命令错误提示待定
   {        
     $CheckLog .= "<font color='red'>$_</font>\n";
     $errnum +=2;
     $errFlag = 6;
     $result = "E";
     last;
   }
	if($iii==0)
	{
    $CheckLog .= "<strong>$line</strong>\n"
  }
	else
	{
		$CheckLog .= "$line \n";
	}
	print "***当前行记录：$line\n";
	
	if($line=~/^\s*Clock\s+status:\s*(\w+)\s*$/i)#   Clock status: synchronized 
		{
			$ClockStatus=lc($1);
			print "***目标1行记录：$line\n";
			print "***目标1值 Clock status: $ClockStatus\n";	
			last;				
		}		
		
	$iii++;  
	
	
}

if( $ClockStatus ne 'synchronized')
{
	print "***时钟同步巡检结果异常，当前状态：$ClockStatus\n";
	$result='E';
}
else
{
	print "***时钟同步巡检正常\n";
}


my $scoreValue = $errnum? $sValue + ($errnum-1)*$mValue:0;
$scoreValue = $maxValue if($scoreValue<$maxValue && $maxValue != 0);

if($errFlag!=6 && $errFlag){
    $CheckLog .= "<font color='red'>捆绑端口($errorTrunks)状态异常，请立即通知包机人处理。</font>\n";
}

if($errFlag==6){
    $CheckLog .= "<font color='red'>命令错误或者命令权限不足</font>\n" ;
}

$CheckLog .= "<font color='blue'>1.Clock status 为synchronized正常，否则异常</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1; 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
