#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_NatSessionUsage ############
# �ļ�����: Ѳ��ģ�庯��
# ��������: M9000  NAT ����Sessionʹ����Ѳ��
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

#step 1 dis dev �ҵ�NSQ1FWCEA0���Ͱ忨���ڲ�λ�š�CPU
exec_cmd('dis dev');  

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="����ִ�д���: $CMD_ERROR";
  return -1;
}
$iii=0;
foreach (@RESULT) #ȡ����λ�š�CPU
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
	print "***��ǰ�м�¼��$_\n";
	if($_=~/^\s*\d+\s*NSQ1FWCEA0\s*.*/i)
	{
		$next_iii=$iii+1;
		print "***Ŀ���м�¼1��$RESULT[$iii]\n";
		print "***Ŀ���м�¼2��$RESULT[$next_iii]\n";
		
		@tmp1Array=split(' ',$RESULT[$iii]);
		@tmp2Array=split(' ',$RESULT[$next_iii]);

		$SlotNo=$tmp1Array[0];
		$CPUNo=$tmp2Array[1];
		print "���ڲ�λ��:$SlotNo;CPU:$CPUNo��\n";
		last;
	}
	$iii++;  
	
	
}
#
##step 2 dis session statistics slot �� cpu �����鿴Current sessions��Session establishment rate�����ޣ�16000000�� 400000�����������쳣

	exec_cmd("dis session statistics slot $SlotNo cpu $CPUNo");
	if ($CMD_ERROR ne '')
	{
 	 $TMP_RESULT="����ִ�д���: $CMD_ERROR";
  	return -1;
	}
	
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
		if($line=~/^\s*Current\s*sessions:\s*(\d+)\s*$/i)#Current sessions: 528947      
		{
			$CurrentSessions=$1;
			print "***Ŀ���м�¼��$line\n";
			print "***Ŀ��1ֵCurrent sessions: $CurrentSessions\n";
			
			if($CurrentSessions > 16000000 )
			{
				print "***Current sessions������ֵ\n";
				$result='E';
			}
			else
			{
				print "***Current sessions����\n";
			}
						
		}
		
		if($line=~/^\s*Session\s*establishment\s*rate:\s*(\d+)\/s\s*/i) #Session establishment rate: 8136/s
		{
			$SessionEstablishmentRate=$1;
			print "***Ŀ���м�¼��$line\n";
			print "***Ŀ��1ֵSession establishment rate:$SessionEstablishmentRate\n";
			if($SessionEstablishmentRate > 400000 )
			{
				print "***Session establishment rate������ֵ\n";
				$result='E';
			}
			else
			{
				print "***Session establishment rate����\n";
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

$CheckLog .= "<font color='blue'>1.�鿴Current sessions��Session establishment rate�����ޣ�16000000�� 400000�����������쳣</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1; 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        