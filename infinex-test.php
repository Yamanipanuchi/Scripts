<?php

use Decimal\Decimal;

$ini_array = parse_ini_file("api.ini");
$api_key = ($ini_array['api']);

for($i = 1; $i < $argc; $i++) {
    $filters[$i - 1] = $argv[$i];
}

$filename = $filters[0];

$ini_array = parse_ini_file($filename);
$pair = ($ini_array['pair']); 
$symbol = ($ini_array['symbol']);
$osize = ($ini_array['osize']);
$oside = ($ini_array['oside']);

$ch = curl_init();
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

/*Get current Low/High*/

/*curl -X POST https://api.vayamos.cc/spot/orderbook -H 'Content-Type: application/json' -d '{"pair": "CAC/USDT"}'*/


curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/orderbook');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['pair' => $pair]));

$result = json_decode(curl_exec($ch), true);

$highestBidDec = new Decimal($result['bids'][0]['price']);
$highestBidStr = $highestBidDec->toFixed(7);

$lowestAskDec = new Decimal($result['asks'][0]['price']);
$lowestAskStr = $lowestAskDec->toFixed(7);

echo 'Pair: '.$pair.' Highest bid: '.$highestBidStr.' Lowestbid: '.$lowestAskStr."\n";

/*Get avblbalance*/

/*curl -X POST https://api.vayamos.cc/wallet/balances -H 'Content-Type: application/json' -d '{"api_key": "0000000000000000000000000000000000", "offset": 0, "search": "LLC"}'*/

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/wallet/balances');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['api_key' => $api_key, 'offset' => 0, 'search' => $symbol]));

$result = json_decode(curl_exec($ch), true);

$avblBalanceDec = new Decimal($result['balances'][$symbol]['avbl']);
$avblBalanceStr = $avblBalanceDec->toFixed(7);

echo 'Balance: '.$avblBalanceStr."\n";

/*Maths*/

$mybid = $highestBidDec + '0.0000001';
$mybid = $mybid->toFixed(7);
$amountDec = ($osize / $highestBidDec);

$amountStr = $amountDec->toFixed(0);

if (($mybid*$amountDec) > $avblBalanceDec){echo 'Insufficient Funds.'."\n";exit;}

/*Get Open Order*/

/*curl -X POST https://api.vayamos.cc/spot/open_orders -H 'Content-Type: application/json' -d '{"api_key": "0000000000000000000000000000000000", "offset": 0, "filter_pair": "LLC/USDT"}'*/

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/open_orders');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['api_key' => $api_key, 'offset' => 0, 'filter_pair' => $pair]));

$result = json_decode(curl_exec($ch), true);

if (empty($result['orders'])){} else {

foreach($result['orders'] as $side) {if($side['side'] === $oside) {$price = $side['price'];break;}}
if ($price == $highestBidDec){echo 'Current order already lowest price'."\n";
echo 'Price '.$price.' - Mybid '.$highestBidDec."\n";
exit;}}

if (empty($result['orders'])){echo 'Currently no open orders'."\n";} else {foreach($result['orders'] as $side) {if($side['side'] === $oside) {$order = $side['obid'];break;}}}

/*Cancel Current order*/

/*curl -X POST https://api.vayamos.cc/spot/open_orders/cancel -H 'Content-Type: application/json' -d '{"api_key": "0000000000000000000000000000000000", "obid": 20}'*/

if (empty($result['orders'])){} else {

echo 'Cancel order #'.$order." - ";

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/open_orders/cancel');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['api_key' => $api_key, 'obid' => $order]));

$result = json_decode(curl_exec($ch), true);

$success = ($result['success']);
if ($success == '0'){$error = ($result['error']);}

if ($success == '1'){echo 'Successfully canceled';} else {echo $error;}

echo "\n";}

/*Open new Order*/

/*curl -X POST https://api.vayamos.cc/spot/open_orders/new -H 'Content-Type: application/json' -d '{"api_key": "0000000000000000000000000000000000", "pair": "CAC/USDT", "side": "BUY", "type": "LIMIT", "time_in_force": "GTC", "price": "0.001", "amount": "500"}'*/

echo 'Open '.$oside.' order for '.$pair.', '.$amountStr.' for $'.$mybid." - ";

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/open_orders/new');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['api_key' => $api_key, 'pair' => $pair, 'side' => $oside, 'type' => 'LIMIT', 'time_in_force' => 'GTC', 'price' => $mybid, 'amount' => $amountDec->toFixed(0)]));

$result = json_decode(curl_exec($ch), true);

$success = ($result['success']);
if ($success == '0'){$error = ($result['error']);}

if ($success == '1'){echo 'Successfully Posted';} else {echo $error;} 

echo "\n";


?>
