net use X: '\\aze1fsrvstrp2.file.core.windows.net\xdrive\Prodshare'  VFHzu0IQX/phUrpmumi1KMr3AM4h16cU0AjpdoeNhbpxZCcGUQLa410vHgiNzy3zXG1m0KZJsKeyS0IbUHicMQ== /user:'Arure\aze1fsrvstrp2' /persistent:Yes 
mkdir C:\run_wallingford-meterdata
cd C:\run_wallingford-meterdata
# Assume python is already installed, if not, use livio's configure_workstation.bat script
poetry init --name run_meterdata --author n --python ^3.11 -n
$venv_info = @(poetry env use python) #(instruction: grab the text from pos 18 to end) should be something like C:\Users\sofiane.rebouh\AppData\Local\pypoetry\Cache\virtualenvs\run-meterdata-6cLTJ3iV-py3.11
$venv_dir = $venv_info.substring(18)
. $venv_dir\Scripts\activate.ps1 #(it runs something like C:\Users\sofiane.rebouh\AppData\Local\pypoetry\Cache\virtualenvs\run-meterdata-6cLTJ3iV-py3.11\Scripts\activate.ps1)
poetry config repositories.private_pypi_feed https://pkgs.dev.azure.com/BETM/AutomationBackOffice/_packaging/AutomationBackOfficeFeed/pypi/simple
poetry config http-basic.private_pypi_feed livio.fetahu 5mq44kudwhxhq5xbjlgky4momibi6i2tttrczo3zyym3sc4hm72a
poetry source add --secondary private_pypi_feed https://pkgs.dev.azure.com/BETM/AutomationBackOffice/_packaging/AutomationBackOfficeFeed/pypi/simple
poetry add --source private_pypi_feed wallingford-meterdata
#python -m wallingford_meterdata --log_path """C:\\Jobs\\WallingfordMeter\\Logs\\""" --a2_submission_output_path """X:\\07_Ops\\Adapt2 Files\\Bid\\""" --email_submission_output_path """X:\\07_Ops\\Adapt2 Files\\Report\\LS Power\\Wallingford\\Meter Data\\""" --rawdata_output_path """C:\\Jobs\\WallingfordMeter\\RawData\\""" --email_submission_output_prefix """ISONE_WallingFord_Meter_""" --chromeDriver """C:\Program Files\Google\Chrome\Application\chromedriver.exe"""
python -m wallingford_meterdata --log_path """C:\\Jobs\\WallingfordMeter\\Logs\\""" --a2_submission_output_path """X:\\07_Ops\\Adapt2 Files TEST\\Bid\\""" --email_submission_output_path """X:\\07_Ops\\Adapt2 Files TEST\\Report\\LS Power\\Wallingford\\Meter Data\\""" --rawdata_output_path """C:\\Jobs\\WallingfordMeter\\RawData\\""" --email_submission_output_prefix """ISONE_WallingFord_Meter_""" --chromeDriver """C:\Program Files\Google\Chrome\Application\chromedriver.exe""" 
$Project_folder= $venv_dir.Split('\')[-1]
poetry env remove $Project_folder