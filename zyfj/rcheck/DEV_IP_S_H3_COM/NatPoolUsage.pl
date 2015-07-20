#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_NatPoolUsage ############
# �ļ�����: Ѳ��ģ�庯��
# ��������: M9000  NAT ��ַ��ʹ����
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
my $TotalDynamicPort=0;
my $ActiveDynamicPort=0;

my $errorTrunks;

exec_cmd('');
$DevType = $RESULT[$#RESULT];
print "******DevType:$DevType \n";

#step 1 dis nat statistics,��עTotal dynamic port block entries��Active dynamic port block entries����ָ��
exec_cmd('dis nat statistics');  

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
	
	if($line=~/^\s*Total\s+dynamic\s+port\s+block\s+entries:\s*(\d+)\s*$/i)#  Total dynamic port block entries: 32768 
		{
			$TotalDynamicPort=$1;
			print "***Ŀ��1�м�¼��$line\n";
			print "***Ŀ��1ֵTotal dynamic port block entries: $TotalDynamicPort\n";					
		}
		
	if($line=~/^\s*Active\s+dynamic\s+port\s+block\s+entries:\s*(\d+)\s*$/i)#    Active dynamic port block entries: 11951 
		{
			$ActiveDynamicPort=$1;
			print "***Ŀ��2�м�¼��$line\n";
			print "***Ŀ��2ֵActive dynamic port block entries: $ActiveDynamicPort\n";					
		}
		
		
	$iii++;  
	
	
}

if($ActiveDynamicPort/$TotalDynamicPort > 0.4)
{
	print "***NAT ��ַ��ʹ���ʸ澯��������ֵ\n";
	$result='E';
}
else
{
	print "***NAT ��ַ��ʹ��������\n";
}


my $scoreValue = $errnum? $sValue + ($errnum-1)*$mValue:0;
$scoreValue = $maxValue if($scoreValue<$maxValue && $maxValue != 0);

if($errFlag!=6 && $errFlag){
    $CheckLog .= "<font color='red'>����˿�($errorTrunks)״̬�쳣��������֪ͨ�����˴���</font>\n";
}

if($errFlag==6){
    $CheckLog .= "<font color='red'>��������������Ȩ�޲���</font>\n" ;
}

$CheckLog .= "<font color='blue'>1.��עTotal dynamic port block entries��Active dynamic port block entries����ָ�꣬ʹ���ʳ���40%�澯</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1; 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
