#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_LightPower ############
# 文件类型: 巡检模板函数
# 基本功能: M9000  光功率
# 修改日期, 修改人,任务id/bugid,详细设计文档名,描述
# 20150716  wangguorong   增加判断条件，按设备属性单独出NE40―X16路由器
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


my $iii=0;
my $iii_cnt=0;

my $errorTrunks;

exec_cmd('');
$DevType = $RESULT[$#RESULT];
print "******DevType:$DevType \n";

#step 1 dis link-aggregation verbose Route-Aggregation查看捆绑口绑定物理口
exec_cmd('dis link-aggregation verbose Route-Aggregation');  

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="命令执行错误: $CMD_ERROR";
  return -1;
}
$iii=0;
foreach (@RESULT) #取出捆绑口绑定物理口
{
	if($_=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i)      #命令错误提示待定
   {        
     $CheckLog .= "<font color='red'>$_</font>\n";
     $errnum +=2;
     $errFlag = 6;
     $result = "E";
     last;
   }
	if($iii==0)
	{
    $CheckLog .= "<strong>$_</strong>\n"
  }
	else
	{
		$CheckLog .= "$_ \n";
	}
	$iii++;  
	if($_=~/XGE0\/\d\/\d/)
	{
		print "***目标行记录：$_\n";
		print "***匹配出来的目标串：$&\n";
		push(@port,substr($&,3));
	}
}

foreach (@port)
{
	print "***物理端口：$_\n";
}
#step 2 dis transceiver diagnosis interface Ten-GigabitEthernet X/X/X 命令查看物理口光功率
foreach (@port)
{
	$cur_port=$_;
	exec_cmd("dis transceiver diagnosis interface Ten-GigabitEthernet $cur_port");
	if ($CMD_ERROR ne '')
	{
 	 $TMP_RESULT="命令执行错误: $CMD_ERROR";
  	return -1;
	}
	
	$status='';
	$iii=0;
	foreach my $line (@RESULT)
	{
		if($_=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i)      #命令错误提示待定
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
		$iii++; 
		if($line=~/^\s*\d+\s+\S+\s+\S+\s+(\S+)\s+(\S+)\s*$/)#    35         3.34        45.05     -17.90         -1.48          
		{
			print "***目标行记录：$line\n";
			print "***目标1值：$1;目标2值：$2。\n";
			
		#	if($1 > 2.50 or $1 < -12.30 )
		#	{
		#		print "***$cur_port物理口RX power 光功率超出阀值\n";
		#		$result='E';
		#	}
		#	else
		#	{
		#		print "***$cur_port物理口RX power光功率正常\n";
		#	}
		#	
		#	if($2 > 2.50 or $2 < -12.30 )
		#	{
		#		print "***$cur_port物理口TX power光功率超出阀值\n";
		#		$result='E';
		#	}
		#	else
		#	{
		#		print "***$cur_port物理口TX power光功率正常\n";
		#	}
			
		}
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

$CheckLog .= "<font color='blue'>1.端口收发功率超过上下门限则告警</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         