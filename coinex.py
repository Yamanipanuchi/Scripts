import time
import hashlib
import requests

access_id = ''
secret_key = ''

base_url = 'https://api.coinex.com/perpetual/v1'


def get_sign(params,secret_key):
    data = []
    for item in params:
        data.append(item + '=' + str(params[item]))
    str_params = "{0}&secret_key={1}".format('&'.join(data), secret_key)
    token = hashlib.sha256(str_params.encode()).hexdigest().lower()
    return token

def Adjust_Leverage():
    header = {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36'
    }
    timestamp = int(time.time()*1000)
    params = {
        'market': 'BTCUSDT',
        'leverage':'10',
        'position_type':1,
        'timestamp':timestamp}
    header['Authorization'] = get_sign(params , secret_key)
    header['AccessId'] = access_id
    res = requests.post(
        url=f'{base_url}/market/adjust_leverage',
        headers=header,
        json=params
        )
    return res.text


def Market_Order():
    header = {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36'
    }
    timestamp = int(time.time()*1000)
    params = {
        'market': 'BTCUSDT',
        'side':1,
        'amount':'10',
        'timestamp':timestamp}
    header['authorization'] = get_sign(params , secret_key)
    header['AccessId'] = access_id
    res = requests.post(
        url=f'{base_url}/order/put_market',
        headers=header,
        json=params
        )
    return res.text

print(Adjust_Leverage())
