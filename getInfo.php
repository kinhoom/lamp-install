<?php
$ini  = file_get_contents('/var/www/web/Conf/vod.ini');
echo "<pre>";
$ini_arr=parse_ini_string($ini,1);
$ext_path=$ini_arr['general']['ext_path'];
var_dump($ext_path);
$free=round(disk_free_space($ext_path)/(1024*1024*1024),1);
$total=round(disk_total_space($ext_path)/(1024*1024*1024),1);

var_dump($free,$total);
$tmp = file_get_contents("./info");
preg_match_all('/(\d+.\d+)\sid/', $tmp, $match);
//cpu
if(count($match)==2)
	$cpu_info=round(100-$match[1][1],1);
//mem
preg_match_all('/(\d+)\s+total/', $tmp, $match);
if(isset($match[1][0]))
	$total_mem=round($match[1][0]/1024,0);
preg_match_all('/(\d+)\s+used/', $tmp, $match);
if(isset($match[1][0]))
        $use_mem=round($match[1][0]/1024,0);
preg_match_all('/(\d+)\s+free/', $tmp, $match);
if(isset($match[1][0]))
        $free_mem=round($match[1][0]/1024,0);
preg_match_all('/(\d+)\s+buff/', $tmp, $match);
if(isset($match[1][0]))
        $buff_mem=round($match[1][0]/1024,0);
$eth = array();
preg_match_all("/(em\d|enp\d|eth\d|ens\d|bond)\w*/",$tmp, $eth_info);
for($i=0;$i<count($eth_info[0])/2;$i++){
	$eth[$i]['name'] = $eth_info[0][$i];
	if(preg_match("/{$eth[0]['name']}[\s\S]+(?={$eth[0]['name']})/", $tmp, $allmatch)){
		if ($i==count($eth_info[0])/2-1){
		    preg_match("/{$eth_info[0][$i]}[\s\S]+(?=lo:)/",$allmatch[0], $match);
		   //var_dump($match);
		}
		else {
		    preg_match("/{$eth_info[0][$i]}[\s\S]+(?={$eth_info[0][$i+1]})/",$allmatch[0], $match);
		}
		if(preg_match("/inet (|addr:)(\d+\.\d+\.\d+\.\d+)/", $match[0], $match1)){
		$eth[$i]['ip_info']=$match1[2];
      }
	}
      $eth[$i]['eth_info'] = "断开";
/************************************************
      if (file_exists($this->network_path."ifcfg-ppp".$i)){
var_dump($this->network_path."ifcfg-ppp".$i);
                                    $ppp = $this->getPppoeStatus($i);
var_dump($ppp);
                                    if (isset($ppp)){
                                        if(preg_match("/inet (|addr:)(\d+\.\d+\.\d+\.\d+)/", $this->exec("ifconfig {$ppp}"), $match1)){
                                            if(preg_match("/\d+\.\d+\.\d+\.\d+/", $match1[0], $match2))
                                                $eth[$i]['ip_info'] = $match2[0];
                                        }
                                        if(preg_match("/{$ppp}/",$tmp, $match2)){
                                            $eth[$i]['eth_info'] = "连接";
                                        }
                                    }
                                }
                                else{
                                    if(preg_match("/Scope:Link/", $match[0], $match1))
                                        $eth[$i]['eth_info'] = "连接";
                                    else if(preg_match("/link/", $match[0], $match1))
                                        $eth[$i]['eth_info'] = "连接";
                                }
**************************************************/
	if(preg_match("/link/", $match[0], $match1))
		$eth[$i]['eth_info']='连接';
	if(preg_match("/TX bytes:(\d+)/", $match[0], $match1)){
	    $eth[$i]['send1'] = $match1[1];
	}else if(preg_match("/TX.+ bytes (\d+)/", $match[0], $match1)){
            $eth[$i]['send1'] = $match1[1];
        }
	if(preg_match("/RX bytes:(\d+)/", $match[0], $match1)){
	    $eth[$i]['receive1'] = $match1[1];
	}
	else if(preg_match("/RX.+ bytes (\d+)/", $match[0], $match1)){
	    $eth[$i]['receive1'] = $match1[1];
	}
	if(preg_match("/lo:[\s\S]+lo:/", $tmp, $allmatch)){
	    if ($i==count($eth_info[0])/2-1){
             	preg_match("/{$eth_info[0][$i]}[\s\S]+(?=lo:)/",$allmatch[0], $match);
            }else{
		preg_match("/{$eth_info[0][$i]}[\s\S]+(?={$eth_info[0][$i+1]})/",$allmatch[0], $match);
	    }
	   	var_dump($match); 
		if(preg_match("/TX bytes:(\d+)/", $match[0], $match1)){
		    $eth[$i]['send2'] = $match1[1];
		}
		else if(preg_match("/TX.+ bytes (\d+)/", $match[0], $match1)){
		    $eth[$i]['send2'] = $match1[1];
		}

		if(preg_match("/RX bytes:(\d+)/", $match[0], $match1)){
		    $eth[$i]['receive2'] = $match1[1];
		}
		else if(preg_match("/RX.+ bytes (\d+)/", $match[0], $match1)){
		    $eth[$i]['receive2'] = $match1[1];
		}
		$eth[$i]['send_info'] = round(($eth[$i]['send2'] - $eth[$i]['send1'])/1024*8,1);
                $eth[$i]['receive_info'] = round(($eth[$i]['receive2'] - $eth[$i]['receive1'])/1024*8,1);
	}
}
var_dump($eth);
