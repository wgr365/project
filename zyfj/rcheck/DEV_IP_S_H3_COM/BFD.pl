#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_BFD ############
# �ļ�����: Ѳ��ģ�庯��
# ��������: M9000  BFD״̬���
# �޸�����, �޸���,����id/bugid,��ϸ����ĵ���,����
# 20150720  wangguorong   �����ж����������豸���Ե�����NE40�DX16·����
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
my @BFDStatus;



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

#step 1 	dis bfd session�����������State ΪUp������
exec_cmd('dis bfd session');  

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
	
	if($line=~/^\s*\d+\/\d+\s+(\d+\.\d+\.\d+\.\d+)\s+(\d+\.\d+\.\d+\.\d+)\s+(\w+)\s+\d+ms\s+RAGG[1-2]\s*$/i)# 108/22171      218.6.31.217    218.6.31.218    Up       436ms       RAGG1      
	{
		print "***Ŀ���¼:$line\n";
		print "***Ŀ��ƥ�䴮:$3\n";

		push(@BFDStatus,uc($3));
	}
	$iii++;  
	
	
}

$iscalar=@BFDStatus;
print "***scalar =$iscalar \n";

foreach (@BFDStatus)
{
	if ($_ ne uc('up'))
	{
		print "***BFD״̬����쳣��$_\n";
 		$result='E';
	}
	else
	{
		print "***BFD״̬���������$_\n";
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

$CheckLog .= "<font color='blue'>1.dis bfd session�����������State ΪUp������</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1; 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
