#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_NatSessionUsage ############
# 文件类型: 巡检模板函数
# 基本功能: M9000  NAT 单板Session使用率巡检
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
my @tmp1Array;
my @tmp2Array;




my $iii=0;
my $iii_cnt=0;
my $next_iii=0;
my $SlotNo=100;
my $CPUNo=100;
my $CurrentSessions=0;
my $SessionEstablishmentRate=0;

my $errorTrunks;

exec_cmd('');
$DevType = $RESULT[$#RESULT];
print "******DevType:$DevType \n";

#step 1 dis dev 找到NSQ1FWCEA0类型板卡所在槽位号、CPU
exec_cmd('dis dev');  

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="命令执行错误: $CMD_ERROR";
  return -1;
}
$iii=0;
foreach (@RESULT) #取出槽位号、CPU
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
	print "***当前行记录：$_\n";
	if($_=~/^\s*\d+\s*NSQ1FWCEA0\s*.*/i)
	{
		$next_iii=$iii+1;
		print "***目标行记录1：$RESULT[$iii]\n";
		print "***目标行记录2：$RESULT[$next_iii]\n";
		
		@tmp1Array=split(' ',$RESULT[$iii]);
		@tmp2Array=split(' ',$RESULT[$next_iii]);

		$SlotNo=$tmp1Array[0];
		$CPUNo=$tmp2Array[1];
		print "所在槽位号:$SlotNo;CPU:$CPUNo。\n";
		last;
	}
	$iii++;  
	
	
}
#
##step 2 dis session statistics slot ？ cpu ？，查看Current sessions和Session establishment rate，门限（16000000和 400000），超过则异常

	exec_cmd("dis session statistics slot $SlotNo cpu $CPUNo");
	if ($CMD_ERROR ne '')
	{
 	 $TMP_RESULT="命令执行错误: $CMD_ERROR";
  	return -1;
	}
	
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
		if($line=~/^\s*Current\s*sessions:\s*(\d+)\s*$/i)#Current sessions: 528947      
		{
			$CurrentSessions=$1;
			print "***目标行记录：$line\n";
			print "***目标1值Current sessions: $CurrentSessions\n";
			
			if($CurrentSessions > 16000000 )
			{
				print "***Current sessions超出阀值\n";
				$result='E';
			}
			else
			{
				print "***Current sessions正常\n";
			}
						
		}
		
		if($line=~/^\s*Session\s*establishment\s*rate:\s*(\d+)\/s\s*/i) #Session establishment rate: 8136/s
		{
			$SessionEstablishmentRate=$1;
			print "***目标行记录：$line\n";
			print "***目标1值Session establishment rate:$SessionEstablishmentRate\n";
			if($SessionEstablishmentRate > 400000 )
			{
				print "***Session establishment rate超出阀值\n";
				$result='E';
			}
			else
			{
				print "***Session establishment rate正常\n";
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

$CheckLog .= "<font color='blue'>1.查看Current sessions和Session establishment rate，门限（16000000和 400000），超过则异常</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1; 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        