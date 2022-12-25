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



![[截圖 2022-12-25 下午6.22.43.png | 450]]

--- 

<div style="page-break-after: always;"></div>

### Example:

Global

![[截圖 2022-12-25 下午6.19.59.png | 450]]

Local (Seasonal)

![[截圖 2022-12-25 下午6.20.22.png | 450]]

Resid

![[截圖 2022-12-25 下午6.20.58.png | 450]]