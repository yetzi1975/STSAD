unit inq;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Spin, Grids, Buttons ;

type
  Tinqform = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  inqform: Tinqform;
  num: integer;
implementation
uses  ent, MAIN;
{$R *.DFM}

procedure Tinqform.FormCreate(Sender: TObject);
var
  i,t1,t2:integer;
  a,b,t3:single;
  strx,stry,strz:string[30];
  pp:pf;
begin
   //   StringGrid1.enabled:=false;
  if curproc=NDQST then
    begin
     num:=0;
      for i:=1 to spf.np do
       if spf.node[i].sel=1 then
          begin
           if num=0 then num:=i
           else num:=-1;
          end;
     if num<0 then     // not single node
       begin
         height:=100;
         label1.top:=10;
         label1.caption:='��������������'+#13+
         '��  ��  ��  ��     ��ѡ�񵥸��ڵ�!'+#13+'��������������';
         label2.caption:='';
         label3.caption:='';
         speedbutton1.hide;
       end
     else   //   single node
     begin
     height:=240;
     label1.top:=5;
     label2.top:=30;
     i:=spf.node[num].ys;
     if i>=100 then strx:=' ��          [1]'
     else strx:=' ��          [0]';
     if (i mod 100)>=10 then stry:=' ��          [1]'
     else stry:=' ��          [0]';
     if (i mod 10)>=1 then strz:=' ��          [1]'
     else strz:=' ��          [0]';

     if spf.node[num].ys>111 then strx:=strx+'(����)';
     if (spf.node[num].ys mod 100)>11 then stry:=stry+'(����)';
     if (spf.node[num].ys mod 10)>1 then strz:=strz+'(����)';

     label1.caption:='�ڵ��:  ['+inttostr(num)+']';
     label2.caption:='�ڵ�����:                 Լ��'+#13+
        ' X: '+format('%10.3f',[spf.node[num].x])+strx+#13
       +' Y: '+format('%10.3f',[spf.node[num].y])+stry+#13
       +' Z: '+format('%10.3f',[spf.node[num].z])+strz;
     label3.caption:='';
     with StringGrid1 do
      begin
       Cells[0,0]:='  ����';
       cells[1,0]:='  X <kN>';
       cells[2,0]:='  Y <kN>';
       cells[3,0]:='  Z <kN>';
       pp:=spf.ndforce;
       i:=0;
       while pp<>nil do
        begin
         i:=i+1;
         if trunc(pp^.kind /10)=1 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=2 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=3 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=4 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=5 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']';
          cells[1,i]:=format('%7.2f',[pp^.header^[num].x]);
          cells[2,i]:=format('%7.2f',[pp^.header^[num].y]);
          cells[3,i]:=format('%7.2f',[pp^.header^[num].z]);
          pp:=pp^.next;
        end;

       end;
     end
    end
  else if curproc=BARQST then
    begin
    stringgrid1.hide;
    speedbutton1.hide;
     num:=0;
      for i:=1 to spf.ne do
        if spf.bar[i].sel=1 then
          begin
           if num=0 then num:=i
           else num:=-1;
          end;
      if num<0 then     //   not single element
       begin
         height:=100;
         label1.top:=10;
         label1.caption:='��������������'+#13+
         '��  ��  ��  ��     ��ѡ�񵥸��˼�!'+#13+'��������������';
         label2.caption:='';
         label3.caption:='';
         speedbutton1.hide;
       end
     else            //   single element
       begin
         height:=200;
         label1.top:=5;
         label2.top:=50;
         label3.Top:=110;
         if spf.bar[num].sec>0 then
           strx:=spf.subsecmat.section[spf.bar[num].sec].name
         else  strx:='       δ����';
         if spf.bar[num].mat>0 then
            stry:=spf.subsecmat.mater[spf.bar[num].mat].name
         else stry:='       δ����';
          t1:=spf.bar[num].nf;
          t2:=spf.bar[num].nl;
          t3:=(spf.node[t1].x-spf.node[t2].x)*
                (spf.node[t1].x-spf.node[t2].x);
          t3:=t3+(spf.node[t1].y-spf.node[t2].y)*
                 (spf.node[t1].y-spf.node[t2].y);
          t3:=t3+(spf.node[t1].z-spf.node[t2].z)*
                  (spf.node[t1].z-spf.node[t2].z);
          t3:=sqrt(t3);
         if (spf.bar[num].sec>0) and (spf.bar[num].mat>0) then
          begin
           a:=t3*spf.subsecmat.mater[spf.bar[num].mat].rwt*9800;   //  T=>N
           b:=a*spf.subsecmat.section[spf.bar[num].sec].area/10000;  // cm2=>m2
           strz:=format('%8.1f',[b]);
          end
         else  strz:='   -----';

         label1.caption:='�˼���:  ['+
           inttostr(num)+']'+#13+#13+'ǰ�ڵ�: [' +inttostr(spf.bar[num].nf)
             +']    ��ڵ�: ['+inttostr(spf.bar[num].nl)+']';
         label2.caption:='�˼�����:       '+format('%8.3f',[t3])
           +' ��'+#13+'�˼�����:       '+strz+' ţ'
           +#13+'�˼�����:         '+strx
           +#13+'�˼�����:             '+stry;
         if (curbv[SOLV]=1) or (curbv[OPT]=1) then
          begin
            label3.caption:=#13+'�˼�����:       '
              +format('%8.3f',[spf.bar[num].force])+'  kN';
            label3.caption:= label3.caption+#13+'�˼�Ӧ��:       '
              +format('%8.1f',[spf.bar[num].sigma])+'  MPa';
          end
         else
          label3.caption:=''+#13+'�˼�������δ����!';
       end;
    end;

end;

procedure Tinqform.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:integer;
begin
  if curproc= NDQST then
   for i:=1 to spf.np do
    spf.node[i].sel:=0
  else if curproc= BARQST then
   for i:=1 to spf.ne do
    spf.bar[i].sel:=0;
  mainform.cleansc;
  spf.drawspt(curdis);
end;

procedure Tinqform.SpeedButton1Click(Sender: TObject);
var
  lds,i,j:integer;
  pp:pf;
begin
   if speedbutton1.caption='λ��' then
     begin
      if (curbv[SOLV]=1) or (curbv[OPT]=1) then
       begin
       speedbutton1.caption:='����';
       with StringGrid1 do
        begin
         Cells[0,0]:='λ��';
         cells[1,0]:=' ��X <mm>';
         cells[2,0]:=' ��Y <mm>';
         cells[3,0]:=' ��Z <mm>';
        end;
        lds:=0;
        for i:=1 to 14 do
         begin
          if spf.comld[i,0]>=0 then   //  comld[1~14,1~5] ��¼���ϵ��
            lds:=lds+1;
         end;
        for i:=1 to lds do
         begin
          spf.PL_readresult(i);
         with StringGrid1 do
          begin
           cells[0,i]:='���['+inttostr(i)+']';
           cells[1,i]:=format('%7.1f',[spf.node[num].dx*1000]);
           cells[2,i]:=format('%7.1f',[spf.node[num].dy*1000]);
           cells[3,i]:=format('%7.1f',[spf.node[num].dz*1000]);
          end;
         end;
       end
      else  messagedlg('�ṹ��δ����!',mtconfirmation,[mbok],0);

     end
   else if speedbutton1.caption='����' then
     begin
      speedbutton1.caption:='λ��';
      for i:=1 to 20 do
        for j:= 0 to 3 do
          with StringGrid1 do
            cells[j,i]:='';
      with StringGrid1 do
       begin
        Cells[0,0]:='����';
        cells[1,0]:='  X <kN>';
        cells[2,0]:='  Y <kN>';
        cells[3,0]:='  Z <kN>';
         //  cells[0,1]:='D1'; cells[0,2]:='D2';
       pp:=spf.ndforce;
       i:=0;
       while pp<>nil do
        begin
         i:=i+1;
         if trunc(pp^.kind /10)=1 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=2 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=3 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=4 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']'
         else if trunc(pp^.kind /10)=5 then
          cells[0,i]:='��['+inttostr(pp^.kind mod 10)+']';
          cells[1,i]:=format('%7.2f',[pp^.header^[num].x]);
          cells[2,i]:=format('%7.2f',[pp^.header^[num].y]);
          cells[3,i]:=format('%7.2f',[pp^.header^[num].z]);
          pp:=pp^.next;
        end;
       end;

     end;
end;

end.