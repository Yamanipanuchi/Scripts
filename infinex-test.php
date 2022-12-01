<?php

$pair = 'BPX/USDT';
$symbol = 'USDT';
$osize = '0.50';
$oside = 'BUY';

use Decimal\Decimal;

$ini_array = parse_ini_file("api.ini");
$api_key = ($ini_array['api']);

function ParseFloat($floatString){
    $LocaleInfo = localeconv();
    $floatString = str_replace($LocaleInfo["mon_thousands_sep"] , "", $floatString);
    $floatString = str_replace($LocaleInfo["mon_decimal_point"] , ".", $floatString);
    return floatval($floatString);
}

$ch = curl_init();
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

/*Get current Low/High*/

/*curl -X POST https://api.vayamos.cc/spot/orderbook -H 'Content-Type: application/json' -d '{"pair": "CAC/USDT"}'*/


curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/orderbook');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['pair' => $pair]));

$result = json_decode(curl_exec($ch), true);

$highestbid = new Decimal($result['bids'][0]['price']);
$highestbid = $highestbid->toFixed(7);

$lowestask = new Decimal($result['asks'][0]['price']);
$lowestask = $lowestask->toFixed(7);

echo 'Pair: '.$pair.' Highest bid: '.$highestbid.' Lowestbid: '.$lowestask."\n";

/*Get avblbalance*/

/*curl -X POST https://api.vayamos.cc/wallet/balances -H 'Content-Type: application/json' -d '{"api_key": "0000000000000000000000000000000000", "offset": 0, "search": "LLC"}'*/

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/wallet/balances');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['api_key' => $api_key, 'offset' => 0, 'search' => $symbol]));

$result = json_decode(curl_exec($ch), true);

$avblbalance = new Decimal($result['balances'][$symbol]['avbl']);
$avblbalance = $avblbalance->toFixed(7);

echo 'Balance: '.$avblbalance."\n";

/*Maths*/

$mybid = $highestbid + 0.00001;

echo $osize."\n";
echo $highestbid."\n";
echo $mybid."\n";

$amount = ($osize / $highestbid);
echo $amount."\n";

$amount = $amount -> toFixed(4);
echo $amount."\n";

/*
echo $mybid."\n";
echo $mybid*$amount."\n";*/

exit;

if (($mybid*$amount) > $avblbalance){echo 'Insufficient Funds.'."\n";exit;}

/*Get Open Order*/

/*curl -X POST https://api.vayamos.cc/spot/open_orders -H 'Content-Type: application/json' -d '{"api_key": "0000000000000000000000000000000000", "offset": 0, "filter_pair": "LLC/USDT"}'*/

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/open_orders');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'api_key' => $api_key,
    'offset' => 0,
    'filter_pair' => $pair
]));

$result = json_decode(curl_exec($ch), true);

foreach($result['orders'] as $side) {
    if($side['side'] === $oside) {
        $order = $side['obid'];
        break;
    }
}

/*Cancel Current order*/

/*curl -X POST https://api.vayamos.cc/spot/open_orders/cancel -H 'Content-Type: application/json' -d '{"api_key": "0000000000000000000000000000000000", "obid": 20}'*/

echo 'Cancel order #'.$order."\n";

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/open_orders/cancel');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'api_key' => $api_key,
    'obid' => $order
]));

$result = json_decode(curl_exec($ch), true);

$success = ($result['success']);
echo $success;
echo "\n";


/*echo curl_exec($ch);
echo "\n";
*/

/*Open new Order*/

/*curl -X POST https://api.vayamos.cc/spot/open_orders/new -H 'Content-Type: application/json' -d '{"api_key": "0000000000000000000000000000000000", "pair": "CAC/USDT", "side": "BUY", "type": "LIMIT", "time_in_force": "GTC", "price": "0.001", "amount": "500"}'*/

echo 'Open '.$oside.' order for '.$pair.', '.$amount.' for $'.$mybid."\n";

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/open_orders/new');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'api_key' => $api_key,
    'pair' => $pair,
    'side' => $oside,
    'type' => 'LIMIT',
    'time_in_force' => 'GTC',
    'price' => $mybid -> toFixed(5),
    'amount' => $amount
]));

$result = json_decode(curl_exec($ch), true);

$success = ($result['success']);
echo $success;
echo "\n";


?>
