#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_PortBundle ############
# 文件类型: 巡检模板函数
# 基本功能: M9000  端口捆绑
# 修改日期, 修改人,任务id/bugid,详细设计文档名,描述
# 20150714  yanrui   增加判断条件，按设备属性单独出NE40―X16路由器
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

#step 1 dis int brief 查看捆绑口三层状态
exec_cmd('dis int brief');   

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="命令执行错误: $CMD_ERROR";
  return -1;
}

foreach(@RESULT)
{
      if($iii==0){
         $CheckLog .= "<strong>$_</strong>\n"
      }
  
  
    if($_=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i)      #命令错误提示待定
    {        
      $CheckLog .= "<font color='red'>$_</font>\n";
      $errnum +=2;
      $errFlag = 6;
      $result = "E";
      last;
    }
    ###################################################################################
    #取出RAGG1和RAGG2行的记录
    #RAGG1                UP   UP       218.6.31.217    uT:LY-XL-ZHDL-CR-1.MAN.NE50
    #RAGG2                UP   UP       218.6.31.241    uT:LY-XL-LC-CR-1.MAN.NE5000
    ###################################################################################
    if($_=~/RAGG1|RAGG2/)
    {
    	print "***目标行记录：$_\n";
     @line_array=split(' ',$_);#行记录，用空格分割，装入数组中
     $iii_cnt=0;
    	foreach (@line_array)
    	{
    		print "***status $iii_cnt = $line_array[$iii_cnt]\n";
    		$iii_cnt+=1;
    	}
    	$status = uc($line_array[2]);
    	print "***status is ：$status.\n";
    	
    	if($status ne 'UP')
    	{
    		print "***捆绑口三层状态异常。\n";
    		$result='E';
    	}
    	else
    	{
    		print "***捆绑口三层状态正常。\n";
    	}
    	
    }
  
  $CheckLog .= "$_ \n";
  $iii++;   
}

#step 2 dis link-aggregation verbose Route-Aggregation查看捆绑口绑定物理口
exec_cmd('dis link-aggregation verbose Route-Aggregation');  

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="命令执行错误: $CMD_ERROR";
  return -1;
}
$iii=0;
foreach (@RESULT) #取出捆绑口绑定物理口
{
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
#step 3 dis interface Ten-GigabitEthernet X/X/X brief查看物理口状态
foreach (@port)
{
	$cur_port=$_;
	exec_cmd("dis interface Ten-GigabitEthernet $cur_port brief");
	if ($CMD_ERROR ne '')
	{
 	 $TMP_RESULT="命令执行错误: $CMD_ERROR";
  	return -1;
	}
	
	$status='';
	$iii=0;
	foreach my $line (@RESULT)
	{
		if($iii==0)
		{
   	 $CheckLog .= "<strong>$line</strong>\n"
  	}
		else
		{
			$CheckLog .= "$line \n";
		}
		$iii++; 
		if($line=~/XGE$cur_port/)
		{
			print "***目标行记录：$line\n";
			@line_array2=split(' ',$line);
			$status=uc($line_array2[2]);
			print "***目标状态：$status\n";
			
			if($status ne 'UP')
			{
				print "***$cur_port物理口状态异常\n";
				$result='E';
			}
			else
			{
				print "***$cur_port物理口状态正常\n";
			}
			
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

$CheckLog .= "<font color='blue'>判断条件:1.链路捆绑口协议Down则告警，";
$CheckLog .= "2.检查成员端口协议down则告警。";
$CheckLog .= "3.	端口描述中包含processing（不区分大小写）的端口为调测口，不进行判断。</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         