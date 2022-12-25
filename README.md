---
cssclass: codeNote
---
# WebTraffic


--- 
## Trend

function1: 

```python

dp = pd.read_csv(f'{path to file}')

def Traffic(dp):

	# Output: Two pandas DataFrame
	# threshold: mean > 100
	return HighTraffic, LowTraffic 

```

function2: 


```python

HighTraffic, LowTraffic = Traffic(dp)

def Global(HighTraffic):

	# Ourput: Three pandas DataFrame
    return GlobalTrend, LocalTrend, Resid

```

### Output Dataframe format:

有做一次 transpose
Rows: Date, Columns: Web



![datagram](https://imgur.com/CfED7GY)

--- 

<div style="page-break-after: always;"></div>

### Example:

Global

![Global](https://imgur.com/YhHQhJl.jpg)

Local (Seasonal)

![Local](https://imgur.com/nVAra7D.jpg)

Resid

![Resid](https://imgur.com/hIEjibi.jpg)