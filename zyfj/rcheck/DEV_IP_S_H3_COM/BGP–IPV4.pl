#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_ne_bgp_ipv4 ############
# 文件类型: 巡检模板函数
# 基本功能: M9000  BGP-IPV4协议检查
# 修改日期, 修改人,任务id/bugid,详细设计文档名,描述
# 20150720  wangguorong   增加判断条件，按设备属性单独出NE40―X16路由器
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
my @Alarm;
my @ISISStatus;
my @ipv4Status;



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
my $iscalar=0;


my $errorTrunks;

exec_cmd('');
$DevType = $RESULT[$#RESULT];
print "******DevType:$DevType \n";

#step 1 	dis bgp peer ipv4，与33.7、33.8 State为Established则正常
exec_cmd('dis bgp peer ipv4');  

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
	
	if($line=~/^\s*\d+\.\d+\.\d+\.\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+[a-zA-Z0-9]+\s+(\w+)\s*$/i)#      218.6.33.7           64727   287941   283847    0    8808 1963h13m Established		
	{
		print "***目标记录:$line\n";
		print "***目标匹配串:$1\n";

		push(@ipv4Status,uc($1));
	}
	$iii++;  
	
	
}

$iscalar=@ipv4Status;
print "***scalar =$iscalar \n";

foreach (@ipv4Status)
{
	if ($_ ne uc('Established'))
	{
		print "***BGP-IPV4协议检查异常：$_\n";
 		$result='E';
	}
	else
	{
		print "***BGP-IPV4协议检查正常：$_\n";
	}

}

my $scoreValue = $errnum? $sValue + ($errnum-1)*$mValue:0;
$scoreValue = $maxValue if($scoreValue<$maxValue && $maxValue != 0);

if($errFlag!=6 && $errFlag){
    $CheckLog .= "<font color='red'>捆绑端口($errorTrunks)状态异常，请立即通知包机人处理。</font>\n";
}

if($errFlag==6){
    $CheckLog .= "<font color='red'>命令错误或者命令权限不足</font>\n" ;
}

$CheckLog .= "<font color='blue'>1.dis bgp peer ipv4，与33.7、33.8 State为Established则正常</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1; 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
