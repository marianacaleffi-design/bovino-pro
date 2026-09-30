<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BovinoPro — Análise de Eficiência Produtiva</title>
<style>
:root{--bg:#f4f7f2;--card:#fff;--text:#1d2a20;--muted:#657268;--primary:#276749;--primary2:#3182ce;--danger:#c53030;--line:#dce5dd;--shadow:0 8px 24px rgba(31,52,38,.08)}
*{box-sizing:border-box}body{margin:0;font-family:Arial,Helvetica,sans-serif;background:var(--bg);color:var(--text)}
header{background:linear-gradient(135deg,#1f5138,#2f855a);color:#fff;padding:22px 18px;position:sticky;top:0;z-index:5;box-shadow:var(--shadow)}
.header{max-width:1200px;margin:auto;display:flex;justify-content:space-between;gap:15px;align-items:center}.brand h1{margin:0;font-size:25px}.brand p{margin:4px 0 0;opacity:.85;font-size:13px}
.container{max-width:1200px;margin:20px auto;padding:0 14px}.tabs{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:18px}.tab{border:0;background:#e5eee7;color:var(--primary);padding:11px 15px;border-radius:10px;font-weight:700;cursor:pointer}.tab.active{background:var(--primary);color:#fff}
.section{display:none}.section.active{display:block}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:14px}.card{background:var(--card);border:1px solid var(--line);border-radius:15px;padding:17px;box-shadow:var(--shadow);margin-bottom:16px}.card h2,.card h3{margin-top:0}
label{font-size:13px;font-weight:700;color:#415047;display:block;margin-bottom:5px}input,select{width:100%;padding:10px;border:1px solid #cbd8ce;border-radius:9px;font-size:14px;background:#fff}button{border:0;border-radius:9px;padding:10px 14px;font-weight:700;cursor:pointer}.primary{background:var(--primary);color:#fff}.secondary{background:#e8eef8;color:#23558a}.danger{background:#fde8e8;color:var(--danger)}.row{display:flex;gap:9px;flex-wrap:wrap;align-items:end}.row>div{flex:1;min-width:150px}
.kpis{display:grid;grid-template-columns:repeat(auto-fit,minmax(170px,1fr));gap:12px}.kpi{background:#f8fbf8;border:1px solid var(--line);border-radius:12px;padding:14px}.kpi .v{font-size:23px;font-weight:800;color:var(--primary);margin-top:5px}.kpi small{color:var(--muted)}
table{width:100%;border-collapse:collapse;font-size:13px}th,td{padding:10px;border-bottom:1px solid var(--line);text-align:left}th{background:#f1f6f2}td.num{text-align:right}.tablewrap{overflow:auto}
.badge{display:inline-block;padding:5px 8px;border-radius:999px;font-size:11px;font-weight:700;background:#e7f3eb;color:#276749}.badge.warn{background:#fff3cd;color:#8a6400}.badge.bad{background:#fde8e8;color:#a12626}
.note{font-size:12px;color:var(--muted);line-height:1.5}.empty{text-align:center;color:var(--muted);padding:25px}
footer{max-width:1200px;margin:20px auto;padding:0 14px 30px;color:var(--muted);font-size:12px}
@media(max-width:650px){header{position:static}.header{align-items:flex-start;flex-direction:column}.card{padding:14px}}
</style>
</head>
<body>
<header><div class="header"><div class="brand"><h1>🐂 BovinoPro</h1><p>Análise e eficiência produtiva de bovinos de corte</p></div><button class="secondary" onclick="exportData()">Exportar dados</button></div></header>
<div class="container">
<div class="tabs">
<button class="tab active" onclick="showTab('dashboard',this)">Dashboard</button>
<button class="tab" onclick="showTab('lote',this)">Lote</button>
<button class="tab" onclick="showTab('pesagens',this)">Pesagens</button>
<button class="tab" onclick="showTab('custos',this)">Custos</button>
<button class="tab" onclick="showTab('animais',this)">Animais</button>
</div>

<section id="dashboard" class="section active">
<div class="card"><h2>Resumo produtivo</h2><div class="kpis" id="kpis"></div></div>
<div class="card"><h3>Indicadores</h3><div id="indicators"></div></div>
<div class="card"><h3>Últimas pesagens</h3><div class="tablewrap"><table><thead><tr><th>Animal</th><th>Data</th><th>Peso</th><th>GMD</th></tr></thead><tbody id="dashTable"></tbody></table></div></div>
</section>

<section id="lote" class="section">
<div class="card"><h2>Dados do lote</h2>
<div class="grid">
<div><label>Nome do lote</label><input id="loteNome" placeholder="Ex.: Recria 2026"></div>
<div><label>Área (ha)</label><input id="area" type="number" step="0.01"></div>
<div><label>Nº de animais</label><input id="nAnimais" type="number" step="1"></div>
<div><label>Data de entrada</label><input id="entrada" type="date"></div>
<div><label>Data prevista de saída</label><input id="saida" type="date"></div>
<div><label>Peso médio inicial (kg)</label><input id="pesoInicial" type="number" step="0.1"></div>
<div><label>Peso médio atual (kg)</label><input id="pesoAtual" type="number" step="0.1"></div>
<div><label>Peso médio de saída (kg)</label><input id="pesoSaida" type="number" step="0.1"></div>
<div><label>Preço de venda (R$/kg vivo)</label><input id="precoVenda" type="number" step="0.01"></div>
<div><label>Rendimento de carcaça (%)</label><input id="rendimento" type="number" step="0.1" value="50"></div>
</div><br><button class="primary" onclick="saveLote()">Salvar lote</button>
<p class="note">Os dados ficam salvos no navegador deste aparelho.</p></div></section>

<section id="pesagens" class="section">
<div class="card"><h2>Registrar pesagem</h2>
<div class="row">
<div><label>Animal</label><select id="pesoAnimal"></select></div>
<div><label>Data</label><input id="pesoData" type="date"></div>
<div><label>Peso (kg)</label><input id="pesoKg" type="number" step="0.1"></div>
<div><button class="primary" onclick="addPeso()">Adicionar</button></div>
</div></div>
<div class="card"><h3>Histórico</h3><div class="tablewrap"><table><thead><tr><th>Animal</th><th>Data</th><th>Peso</th><th>GMD desde pesagem anterior</th><th></th></tr></thead><tbody id="pesoTable"></tbody></table></div></div>
</section>

<section id="custos" class="section">
<div class="card"><h2>Custos do ciclo</h2>
<div class="grid">
<div><label>Compra dos animais (R$)</label><input id="cCompra" type="number" step="0.01"></div>
<div><label>Alimentação (R$)</label><input id="cAlim" type="number" step="0.01"></div>
<div><label>Sanidade (R$)</label><input id="cSan" type="number" step="0.01"></div>
<div><label>Mão de obra (R$)</label><input id="cMao" type="number" step="0.01"></div>
<div><label>Pastagem (R$)</label><input id="cPasto" type="number" step="0.01"></div>
<div><label>Outros (R$)</label><input id="cOutros" type="number" step="0.01"></div>
<div><label>Consumo de matéria seca (kg MS/dia/animal)</label><input id="cms" type="number" step="0.01" placeholder="Opcional"></div>
<div><label>Conversão alimentar (kg MS/kg ganho)</label><input id="ca" type="number" step="0.01" placeholder="Opcional"></div>
</div><br><button class="primary" onclick="saveCustos()">Salvar custos</button></div>
<div class="card"><h3>Resultado econômico</h3><div id="economic"></div></div>
</section>

<section id="animais" class="section">
<div class="card"><h2>Cadastrar animal</h2>
<div class="row"><div><label>Brinco/ID</label><input id="animalId"></div><div><label>Sexo</label><select id="animalSexo"><option>Macho</option><option>Fêmea</option></select></div><div><label>Raça</label><input id="animalRaca" placeholder="Ex.: Nelore"></div><div><label>Data de entrada</label><input id="animalEntrada" type="date"></div><div><button class="primary" onclick="addAnimal()">Cadastrar</button></div></div></div>
<div class="card"><h3>Animais cadastrados</h3><div class="tablewrap"><table><thead><tr><th>ID</th><th>Sexo</th><th>Raça</th><th>Entrada</th><th></th></tr></thead><tbody id="animalTable"></tbody></table></div></div>
</section>
</div>
<footer>Ferramenta de apoio gerencial. Os indicadores dependem da qualidade dos dados informados e não substituem avaliação técnica de um profissional.</footer>

<script>
const KEY='bovinopro_v1';
let db=JSON.parse(localStorage.getItem(KEY)||'{"lote":{},"custos":{},"animais":[],"pesagens":[]}');
const $=id=>document.getElementById(id);
const num=id=>parseFloat($(id).value)||0;
function save(){localStorage.setItem(KEY,JSON.stringify(db));render();}
function showTab(id,btn){document.querySelectorAll('.section').forEach(x=>x.classList.remove('active'));$(id).classList.add('active');document.querySelectorAll('.tab').forEach(x=>x.classList.remove('active'));btn.classList.add('active');}
function days(a,b){if(!a||!b)return 0;return Math.max(0,(new Date(b)-new Date(a))/86400000)}
function money(v){return (v||0).toLocaleString('pt-BR',{style:'currency',currency:'BRL'})}
function saveLote(){
 db.lote={nome:$('loteNome').value,area:num('area'),nAnimais:num('nAnimais'),entrada:$('entrada').value,saida:$('saida').value,pesoInicial:num('pesoInicial'),pesoAtual:num('pesoAtual'),pesoSaida:num('pesoSaida'),precoVenda:num('precoVenda'),rendimento:num('rendimento')};save();alert('Lote salvo.');
}
function saveCustos(){db.custos={compra:num('cCompra'),alim:num('cAlim'),san:num('cSan'),mao:num('cMao'),pasto:num('cPasto'),outros:num('cOutros'),cms:num('cms'),ca:num('ca')};save();alert('Custos salvos.')}
function addAnimal(){
 let id=$('animalId').value.trim(); if(!id)return alert('Informe o ID do animal.');
 if(db.animais.some(a=>a.id===id))return alert('Esse ID já existe.');
 db.animais.push({id,sexo:$('animalSexo').value,raca:$('animalRaca').value,entrada:$('animalEntrada').value});$('animalId').value='';$('animalRaca').value='';save();
}
function removeAnimal(id){db.animais=db.animais.filter(a=>a.id!==id);db.pesagens=db.pesagens.filter(p=>p.animal!==id);save();}
function addPeso(){
 let animal=$('pesoAnimal').value,data=$('pesoData').value,peso=num('pesoKg');
 if(!animal||!data||!peso)return alert('Preencha animal, data e peso.');
 db.pesagens.push({animal,data,peso});db.pesagens.sort((a,b)=>a.data.localeCompare(b.data));$('pesoKg').value='';save();
}
function removePeso(i){db.pesagens.splice(i,1);save()}
function gmdAnimal(animal,index){
 let ps=db.pesagens.filter(p=>p.animal===animal).sort((a,b)=>a.data.localeCompare(b.data)), p=ps[index];
 if(!p||index===0)return null; let prev=ps[index-1],d=days(prev.data,p.data);return d?(p.peso-prev.peso)/d:null;
}
function calc(){
 const l=db.lote,c=db.custos,n=l.nAnimais||db.animais.length||0;
 const d=days(l.entrada,l.saida),ganho=(l.pesoSaida||l.pesoAtual)-l.pesoInicial;
 const gmd=d?ganho/d:0, area=l.area||0, lotacao=area?n/area:0;
 const custoTotal=Object.values(c).slice(0,6).reduce((a,b)=>a+(b||0),0);
 const custoAnimal=n?custoTotal/n:0, ganhoTotal=ganho*n;
 const custoKg=ganhoTotal>0?custoTotal/ganhoTotal:0;
 const receita=n*(l.pesoSaida||l.pesoAtual)*(l.precoVenda||0);
 const margem=receita-custoTotal-(c.compra||0);
 const arrobas=n*(l.pesoSaida||l.pesoAtual)*(l.rendimento||50)/100/15;
 return {n,d,ganho,gmd,lotacao,custoTotal,custoAnimal,custoKg,receita,margem,arrobas};
}
function render(){
 let l=db.lote,c=db.custos,r=calc();
 ['loteNome','area','nAnimais','entrada','saida','pesoInicial','pesoAtual','pesoSaida','precoVenda','rendimento'].forEach(id=>{let k={loteNome:'nome',area:'area',nAnimais:'nAnimais',entrada:'entrada',saida:'saida',pesoInicial:'pesoInicial',pesoAtual:'pesoAtual',pesoSaida:'pesoSaida',precoVenda:'precoVenda',rendimento:'rendimento'}[id];if($(id))$(id).value=l[k]??''});
 ['cCompra','cAlim','cSan','cMao','cPasto','cOutros','cms','ca'].forEach((id,i)=>{let k=['compra','alim','san','mao','pasto','outros','cms','ca'][i];$(id).value=c[k]??''});
 $('animalTable').innerHTML=db.animais.length?db.animais.map(a=>`<tr><td>${esc(a.id)}</td><td>${esc(a.sexo)}</td><td>${esc(a.raca)}</td><td>${a.entrada||'-'}</td><td><button class="danger" onclick="removeAnimal('${escAttr(a.id)}')">Excluir</button></td></tr>`).join(''):`<tr><td colspan="5" class="empty">Nenhum animal cadastrado.</td></tr>`;
 $('pesoAnimal').innerHTML=db.animais.length?db.animais.map(a=>`<option>${esc(a.id)}</option>`).join(''):'<option value="">Cadastre um animal</option>';
 $('pesoTable').innerHTML=db.pesagens.length?db.pesagens.map((p,i)=>{let ps=db.pesagens.filter(x=>x.animal===p.animal).sort((a,b)=>a.data.localeCompare(b.data));let ix=ps.indexOf(p);let g=gmdAnimal(p.animal,ix);return `<tr><td>${esc(p.animal)}</td><td>${p.data}</td><td>${p.peso.toFixed(1)} kg</td><td>${g===null?'-':g.toFixed(3)+' kg/dia'}</td><td><button class="danger" onclick="removePeso(${i})">Excluir</button></td></tr>`}).join(''):`<tr><td colspan="5" class="empty">Nenhuma pesagem registrada.</td></tr>`;
 $('dashTable').innerHTML=db.pesagens.slice().reverse().slice(0,10).map(p=>{let ps=db.pesagens.filter(x=>x.animal===p.animal).sort((a,b)=>a.data.localeCompare(b.data));let ix=ps.findIndex(x=>x===p);let g=gmdAnimal(p.animal,ix);return `<tr><td>${esc(p.animal)}</td><td>${p.data}</td><td>${p.peso.toFixed(1)} kg</td><td>${g===null?'-':g.toFixed(3)+' kg/dia'}</td></tr>`}).join('')||`<tr><td colspan="4" class="empty">Registre pesagens para acompanhar o desempenho.</td></tr>`;
 $('kpis').innerHTML=[
 ['GMD do ciclo',r.gmd.toFixed(3)+' kg/dia'],['Ganho/animal',r.ganho.toFixed(1)+' kg'],['Lotação',r.lotacao.toFixed(2)+' cab/ha'],['Custo/kg ganho',money(r.custoKg)],['Receita estimada',money(r.receita)],['Margem estimada',money(r.margem)]
 ].map(x=>`<div class="kpi"><small>${x[0]}</small><div class="v">${x[1]}</div></div>`).join('');
 let ca=c.ca, status=r.gmd>=0.7?'adequado':'atenção';
 $('indicators').innerHTML=`<p><span class="badge ${status==='atenção'?'warn':''}">GMD: ${status}</span> — GMD calculado com peso inicial, peso de saída/atual e duração do ciclo.</p>
 <p><span class="badge">Custo total: ${money(r.custoTotal)}</span> <span class="badge">Custo/animal: ${money(r.custoAnimal)}</span> <span class="badge">Arrobas estimadas: ${r.arrobas.toFixed(1)} @</span></p>
 <p>${ca>0?`Conversão alimentar informada: <b>${ca.toFixed(2)} kg MS/kg ganho</b>.`:'Conversão alimentar: informe o valor na aba Custos para calcular/acompanhar esse indicador.'}</p>`;
 $('economic').innerHTML=`<div class="kpis"><div class="kpi"><small>Custo total</small><div class="v">${money(r.custoTotal)}</div></div><div class="kpi"><small>Receita estimada</small><div class="v">${money(r.receita)}</div></div><div class="kpi"><small>Margem estimada</small><div class="v">${money(r.margem)}</div></div><div class="kpi"><small>Custo por kg de ganho</small><div class="v">${money(r.custoKg)}</div></div></div>
 <p class="note">A margem acima é uma estimativa simplificada e depende dos custos e premissas preenchidos.</p>`;
}
function esc(s){return String(s??'').replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]))}
function escAttr(s){return String(s??'').replace(/\\/g,'\\\\').replace(/'/g,"\\'")}
function exportData(){
 const blob=new Blob([JSON.stringify(db,null,2)],{type:'application/json'}),a=document.createElement('a');a.href=URL.createObjectURL(blob);a.download='bovinopro-dados.json';a.click();URL.revokeObjectURL(a.href);
}
render();
</script>
</body>
</html>
