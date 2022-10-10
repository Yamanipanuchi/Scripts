<?php
use Decimal\Decimal;



$ch = curl_init();
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);


echo 'BPX/USDT'."\n";

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/orderbook');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'pair' => 'BPX/USDT'
]));
$result = json_decode(curl_exec($ch), true);

$highestBidBPXUSDT = new Decimal($result['bids'][0]['price']);
echo 'Highest bid: '.$highestBidBPXUSDT->toFixed(7)."\n";

$lowestAskBPXUSDT = new Decimal($result['asks'][0]['price']);
echo 'Lowest ask: '.$lowestAskBPXUSDT->toFixed(7)."\n";


echo 'CAC/USDT'."\n";

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/orderbook');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'pair' => 'CAC/USDT'   
]));
$result = json_decode(curl_exec($ch), true);

$highestBidCACUSDT = new Decimal($result['bids'][0]['price']);
echo 'Highest bid: '.$highestBidCACUSDT->toFixed(7)."\n";

$lowestAskCACUSDT = new Decimal($result['asks'][0]['price']);
echo 'Lowest ask: '.$lowestAskCACUSDT->toFixed(7)."\n";


echo 'CAC/BPX'."\n";

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/orderbook');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'pair' => 'CAC/BPX'
]));
$result = json_decode(curl_exec($ch), true);

$highestBidCACBPX = new Decimal($result['bids'][0]['price']);
echo 'Highest bid: '.$highestBidCACBPX->toFixed(7)."\n";

$lowestAskCACBPX = new Decimal($result['asks'][0]['price']);
echo 'Lowest ask: '.$lowestAskCACBPX->toFixed(7)."\n";

echo "\n";

echo $highestBidCACUSDT * 100;
echo "\n";

$totalCACBPX = $highestBidCACBPX * 100;
echo $highestBidCACBPX * 100;
echo "\n";

echo $totalCACBPX * $highestBidBPXUSDT;
echo "\n";

/*$myBid = $highestBid + '0.00001';
echo 'My bid price: '.$myBid -> toFixed(7)."\n";

curl_setopt($ch, CURLOPT_URL, 'https://api.vayamos.cc/spot/open_orders/new');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'api_key' => '0000000000000',
    'pair' => 'BPX/USDT',
    'side' => 'BUY',
    'type' => 'LIMIT',
    'time_in_force' => 'GTC',
    'price' => $myBid -> toFixed(7),
    'amount' => '3000'
]));
echo curl_exec($ch);*/

?>
