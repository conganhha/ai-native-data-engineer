import json, os
from pathlib import Path
from datetime import datetime
from fastapi import FastAPI, Header, HTTPException, Query

app=FastAPI(title="E-commerce Training Mock API",version="1.0")
DATA=Path(__file__).parent/'data'
API_KEY=os.getenv('API_KEY','training-key')

def load(name):
    return json.loads((DATA/f'{name}.json').read_text(encoding='utf-8'))

def endpoint(name, page, page_size, updated_after, x_api_key):
    if x_api_key != API_KEY: raise HTTPException(401,'Invalid API key')
    rows=load(name)
    if updated_after:
        try: cutoff=datetime.fromisoformat(updated_after.replace('Z','+00:00'))
        except ValueError: raise HTTPException(400,'updated_after must be ISO 8601')
        rows=[r for r in rows if datetime.fromisoformat(r.get('updated_at',r.get('created_at')).replace('Z','+00:00')) > cutoff]
    start=(page-1)*page_size; end=start+page_size
    return {'page':page,'page_size':page_size,'total':len(rows),'has_next':end<len(rows),'data':rows[start:end]}

@app.get('/health')
def health(): return {'status':'ok'}

for path,name in [('customers','customers'),('products','products'),('orders','orders'),('order-items','order-items'),('payments','payments')]:
    def make_handler(dataset):
        def handler(page:int=Query(1,ge=1),page_size:int=Query(100,ge=1,le=500),updated_after:str|None=None,x_api_key:str|None=Header(None)):
            return endpoint(dataset,page,page_size,updated_after,x_api_key)
        return handler
    app.get('/'+path)(make_handler(name))
