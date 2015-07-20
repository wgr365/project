#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_LightPower ############
# �ļ�����: Ѳ��ģ�庯��
# ��������: M9000  �⹦��
# �޸�����, �޸���,����id/bugid,��ϸ����ĵ���,����
# 20150716  wangguorong   �����ж����������豸���Ե�����NE40�DX16·����
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

#step 1 dis link-aggregation verbose Route-Aggregation�鿴����ڰ������
exec_cmd('dis link-aggregation verbose Route-Aggregation');  

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="����ִ�д���: $CMD_ERROR";
  return -1;
}
$iii=0;
foreach (@RESULT) #ȡ������ڰ������
{
	if($_=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i)      #���������ʾ����
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
		print "***Ŀ���м�¼��$_\n";
		print "***ƥ�������Ŀ�괮��$&\n";
		push(@port,substr($&,3));
	}
}

foreach (@port)
{
	print "***����˿ڣ�$_\n";
}
#step 2 dis transceiver diagnosis interface Ten-GigabitEthernet X/X/X ����鿴����ڹ⹦��
foreach (@port)
{
	$cur_port=$_;
	exec_cmd("dis transceiver diagnosis interface Ten-GigabitEthernet $cur_port");
	if ($CMD_ERROR ne '')
	{
 	 $TMP_RESULT="����ִ�д���: $CMD_ERROR";
  	return -1;
	}
	
	$status='';
	$iii=0;
	foreach my $line (@RESULT)
	{
		if($_=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i)      #���������ʾ����
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
			print "***Ŀ���м�¼��$line\n";
			print "***Ŀ��1ֵ��$1;Ŀ��2ֵ��$2��\n";
			
		#	if($1 > 2.50 or $1 < -12.30 )
		#	{
		#		print "***$cur_port�����RX power �⹦�ʳ�����ֵ\n";
		#		$result='E';
		#	}
		#	else
		#	{
		#		print "***$cur_port�����RX power�⹦������\n";
		#	}
		#	
		#	if($2 > 2.50 or $2 < -12.30 )
		#	{
		#		print "***$cur_port�����TX power�⹦�ʳ�����ֵ\n";
		#		$result='E';
		#	}
		#	else
		#	{
		#		print "***$cur_port�����TX power�⹦������\n";
		#	}
			
		}
	}
}



my $scoreValue = $errnum? $sValue + ($errnum-1)*$mValue:0;
$scoreValue = $maxValue if($scoreValue<$maxValue && $maxValue != 0);

if($errFlag!=6 && $errFlag){
    $CheckLog .= "<font color='red'>����˿�($errorTrunks)״̬�쳣��������֪ͨ�����˴���</font>\n";
}

if($errFlag==6){
    $CheckLog .= "<font color='red'>��������������Ȩ�޲���</font>\n" ;
}

$CheckLog .= "<font color='blue'>1.�˿��շ����ʳ�������������澯</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         