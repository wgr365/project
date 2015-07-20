#!/usr/local/bin/perl
##### DEV_IP_S_H3_COM_PortBundle ############
# �ļ�����: Ѳ��ģ�庯��
# ��������: M9000  �˿�����
# �޸�����, �޸���,����id/bugid,��ϸ����ĵ���,����
# 20150714  yanrui   �����ж����������豸���Ե�����NE40�DX16·����
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

#step 1 dis int brief �鿴���������״̬
exec_cmd('dis int brief');   

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="����ִ�д���: $CMD_ERROR";
  return -1;
}

foreach(@RESULT)
{
      if($iii==0){
         $CheckLog .= "<strong>$_</strong>\n"
      }
  
  
    if($_=~/^\s*\%\s+Unrecognized\s+command|^\s*Error\:\s*\S+\s+command/i)      #���������ʾ����
    {        
      $CheckLog .= "<font color='red'>$_</font>\n";
      $errnum +=2;
      $errFlag = 6;
      $result = "E";
      last;
    }
    ###################################################################################
    #ȡ��RAGG1��RAGG2�еļ�¼
    #RAGG1                UP   UP       218.6.31.217    uT:LY-XL-ZHDL-CR-1.MAN.NE50
    #RAGG2                UP   UP       218.6.31.241    uT:LY-XL-LC-CR-1.MAN.NE5000
    ###################################################################################
    if($_=~/RAGG1|RAGG2/)
    {
    	print "***Ŀ���м�¼��$_\n";
     @line_array=split(' ',$_);#�м�¼���ÿո�ָװ��������
     $iii_cnt=0;
    	foreach (@line_array)
    	{
    		print "***status $iii_cnt = $line_array[$iii_cnt]\n";
    		$iii_cnt+=1;
    	}
    	$status = uc($line_array[2]);
    	print "***status is ��$status.\n";
    	
    	if($status ne 'UP')
    	{
    		print "***���������״̬�쳣��\n";
    		$result='E';
    	}
    	else
    	{
    		print "***���������״̬������\n";
    	}
    	
    }
  
  $CheckLog .= "$_ \n";
  $iii++;   
}

#step 2 dis link-aggregation verbose Route-Aggregation�鿴����ڰ������
exec_cmd('dis link-aggregation verbose Route-Aggregation');  

if ($CMD_ERROR ne '')
{
  $TMP_RESULT="����ִ�д���: $CMD_ERROR";
  return -1;
}
$iii=0;
foreach (@RESULT) #ȡ������ڰ������
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
		print "***Ŀ���м�¼��$_\n";
		print "***ƥ�������Ŀ�괮��$&\n";
		push(@port,substr($&,3));
	}
}

foreach (@port)
{
	print "***����˿ڣ�$_\n";
}
#step 3 dis interface Ten-GigabitEthernet X/X/X brief�鿴�����״̬
foreach (@port)
{
	$cur_port=$_;
	exec_cmd("dis interface Ten-GigabitEthernet $cur_port brief");
	if ($CMD_ERROR ne '')
	{
 	 $TMP_RESULT="����ִ�д���: $CMD_ERROR";
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
			print "***Ŀ���м�¼��$line\n";
			@line_array2=split(' ',$line);
			$status=uc($line_array2[2]);
			print "***Ŀ��״̬��$status\n";
			
			if($status ne 'UP')
			{
				print "***$cur_port�����״̬�쳣\n";
				$result='E';
			}
			else
			{
				print "***$cur_port�����״̬����\n";
			}
			
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

$CheckLog .= "<font color='blue'>�ж�����:1.��·�����Э��Down��澯��";
$CheckLog .= "2.����Ա�˿�Э��down��澯��";
$CheckLog .= "3.	�˿������а���processing�������ִ�Сд���Ķ˿�Ϊ����ڣ��������жϡ�</font>\n";


logCheckResult2DB($result,$CheckLog,$errFlag,$errnum,$scoreValue,"");

return 1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         