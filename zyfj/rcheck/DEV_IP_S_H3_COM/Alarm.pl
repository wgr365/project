#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_Alarm ############
# �ļ�����: Ѳ��ģ�庯��
# ��������: M9000  �豸�澯
# �޸�����, �޸���,����id/bugid,��ϸ����ĵ���,����
# 20150717  wangguorong   �����ж����������豸���Ե�����NE40�DX16·����
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

#step 1 dis alarm ,�����쳣��ע���ų�Power 2/3/4/5 is absent�������澯
exec_cmd('dis alarm');  

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="����ִ�д���: $CMD_ERROR";
  return -1;
}
$iii=0;
foreach my $line (@RESULT) #ȡ��Ŀ����
{
	if($line=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i)      #���������ʾ����
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
	print "***��ǰ�м�¼��$line\n";
	
	if($line=~/^\s*Slot\s+CPU\s+Level\s+Info\s*$/i)#   Slot   CPU   Level   Info  ���˱���
		{
			print "***�����У�$line\n";
		}	
	elsif($line=~/^\s*-\s+-\s+INFO\s+Power\s+[2-5]\s+is\s+absent\.\s*$/i)#-      -     INFO    Power 2 is absent. ����Power 2/3/4/5 is absent�������澯	
		{
			print "***�����У�$line\n";
		}
	elsif($line=~/^\s*<LY-XL-ZHDL-BAS-2.MAN.M9010>\s*|^\s*dis\s+alarm\s*$/i)#<LY-XL-ZHDL-BAS-2.MAN.M9010> ���˽�������һ�� �� ������dis alarm
	{
		print "***���˽�������һ�л������У�$line\n";
	}
	else
	{
		print "***�澯�м�¼:$line\n";
		push(@Alarm,$line);
	}
	$iii++;  
	
	
}

$iscalar=@Alarm;
print "***scalar =$iscalar \n";
if (@Alarm > 0)
{
	print "***�豸�澯�쳣���澯��¼��\n";
	print "@Alarm\n";
  $result='E';
}
else
{
	print "***�豸�澯������\n";
}


my $scoreValue = $errnum? $sValue + ($errnum-1)*$mValue:0;
$scoreValue = $maxValue if($scoreValue<$maxValue && $maxValue != 0);

if($errFlag!=6 && $errFlag){
    $CheckLog .= "<font color='red'>����˿�($errorTrunks)״̬�쳣��������֪ͨ�����˴���</font>\n";
}

if($errFlag==6){
    $CheckLog .= "<font color='red'>��������������Ȩ�޲���</font>\n" ;
}

$CheckLog .= "<font color='blue'>1.dis alarm ,�����쳣��ע���ų�Power 2/3/4/5 is absent�������澯</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1; 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
