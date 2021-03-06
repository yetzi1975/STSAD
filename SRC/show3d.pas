unit show3d;

interface

uses Windows, ent;

type
  p_Tspg = ^Tspg;

procedure CreateDC(Handle:HWND);
procedure myDraw(ss: p_Tspg; sc, ax,ay,az,bax,bay: single; flag:byte);

implementation

uses
OpenGL, Messages, SysUtils, Classes, Controls, Forms, Graphics, Dialogs,
StdCtrls, ExtCtrls, ComCtrls, math;
// 
Var
  MyQuadratic : GLUquadricObj;
  angle : single;

procedure setupPixelFormat(DC:HDC);
const
pfd:TPIXELFORMATDESCRIPTOR = (
nSize:sizeof(TPIXELFORMATDESCRIPTOR);    // size
nVersion:1;                              // version
dwFlags:PFD_SUPPORT_OPENGL or PFD_DRAW_TO_WINDOW or
PFD_DOUBLEBUFFER;                        // support double-buffering
iPixelType:PFD_TYPE_RGBA;                // color type
cColorBits:24;                           // preferred color depth
cRedBits:0; cRedShift:0;                 // color bits (ignored)
cGreenBits:0; cGreenShift:0;
cBlueBits:0; cBlueShift:0;
cAlphaBits:0; cAlphaShift:0;             // no alpha buffer
cAccumBits: 0;
cAccumRedBits: 0;                        // no accumulation buffer,
cAccumGreenBits: 0;                      // accum bits (ignored)
cAccumBlueBits: 0;
cAccumAlphaBits: 0;
cDepthBits:16;                           // depth buffer
cStencilBits:0;                          // no stencil buffer
cAuxBuffers:0;                           // no auxiliary buffers
iLayerType:PFD_MAIN_PLANE;               // main layer
bReserved: 0; 
dwLayerMask: 0; 
dwVisibleMask: 0; 
dwDamageMask: 0;                   // no layer, visible, damage masks
); 
var pixelFormat:integer; 
begin 
pixelFormat := ChoosePixelFormat(DC, @pfd); 
if (pixelFormat = 0) then 
exit; 
if (SetPixelFormat(DC, pixelFormat, @pfd) <> TRUE) then 
exit; 
end; 

function getNormal(p1,p2,p3:TGLArrayf3):TGLArrayf3; 
var a,b:TGLArrayf3; 
begin 
//make two vectors 
a[0]:=p2[0]-p1[0]; a[1]:=p2[1]-p1[1]; a[2]:=p2[2]-p1[2]; 
b[0]:=p3[0]-p1[0]; b[1]:=p3[1]-p1[1]; b[2]:=p3[2]-p1[2]; 
//calculate cross-product
result[0]:=a[1]*b[2]-a[2]*b[1];
result[1]:=a[2]*b[0]-a[0]*b[2];
result[2]:=a[0]*b[1]-a[1]*b[0];
end;

//  GLInit 用于初始化OpenGL
Procedure GLInit;
const
  light0_position:TGLArrayf4=( -2.0, -2.0, -10.0, 0.0);
  ambient: TGLArrayf4=( 0.1, 0.1, 0.1, 0.0);
  diffuse: TGLArrayf4=( 0.8, 0.8, 0.8, 0.0);
  specular: TGLArrayf4=( 1.0, 1.0, 1.0, 0.0);
begin
// set viewing projection
glMatrixMode(GL_PROJECTION);
glFrustum(-0.1, 0.1, -0.1, 0.1, 0.3, 30.0);
// position viewer */
glMatrixMode(GL_MODELVIEW);
glEnable(GL_DEPTH_TEST);
//
  MyQuadratic := gluNewQuadric();			// Create A Pointer To The Quadric Object (Return 0 If No Memory) (NEW)
  gluQuadricNormals(MyQuadratic, GLU_SMOOTH);
  gluQuadricOrientation(MyQuadratic, GLU_INSIDE);

// gluQuadricNormals(MyQuadratic, GLU_SMOOTH);  	// Create Smooth Normals (NEW)
// gluQuadricTexture(MyQuadratic, GL_TRUE);		// Create Texture Coords (NEW)
// set lights
// glLightModelfv(GL_LIGHT_MODEL_AMBIENT, @ambient);

glEnable(GL_LIGHTING);
glLightfv(GL_LIGHT0, GL_POSITION, @light0_position);
glLightfv(GL_LIGHT0, GL_AMBIENT, @ambient);
glLightfv(GL_LIGHT0, GL_DIFFUSE, @diffuse);	      	// Set The Diffuse Light
glLightfv(GL_LIGHT0, GL_SPECULAR, @specular);	      	// Set Up Specular Lighting
glEnable(GL_LIGHT0);
// glMateriali(GL_FRONT, GL_SHININESS, 128);

end;

procedure CreateDC(Handle:HWND);
var
 DC:HDC;
 RC:HGLRC;
begin
  DC:=GetDC(Handle);      //Actually, you can use any windowed control here
  SetupPixelFormat(DC);
  RC:=wglCreateContext(DC);  //makes OpenGL window out of DC
  wglMakeCurrent(DC, RC);    //makes OpenGL window active
  GLInit;                    //initialize OpenGL
  angle:=0;
end;

procedure drawCube(Rs:single);     //  正方形节点
begin
  glBegin(GL_QUADS);
  // Front Face
  glNormal3f(0.0, 0.0, -1.0);
   glVertex3f(-Rs, -Rs,  Rs);
   glVertex3f( Rs, -Rs,  Rs);
   glVertex3f( Rs, Rs,  Rs);
   glVertex3f(-Rs, Rs,  Rs);
  // Back Face
  glNormal3f(0.0, 0.0, 1.0);
   glVertex3f(-Rs, -Rs, -Rs);
   glVertex3f(Rs, -Rs, -Rs);
   glVertex3f(Rs, Rs, -Rs);
   glVertex3f(-Rs, Rs, -Rs);
  // Top Face
  glNormal3f(0.0, -1.0, 0.0);
   glVertex3f(-Rs,  Rs, -Rs);
   glVertex3f(-Rs,  Rs,  Rs);
   glVertex3f(Rs,  Rs,  Rs);
   glVertex3f(Rs,  Rs, -Rs);
  // Bottom Face
  glNormal3f(0.0, 1.0, 0.0);
   glVertex3f(-Rs, -Rs, -Rs);
   glVertex3f(Rs, -Rs, -Rs);
   glVertex3f(Rs, -Rs,  Rs);
   glVertex3f(-Rs, -Rs,  Rs);
  // Right face
  glNormal3f(-1.0, 0.0, 0.0);
   glVertex3f(Rs, -Rs, -Rs);
   glVertex3f(Rs, Rs, -Rs);
   glVertex3f(Rs, Rs,  Rs);
   glVertex3f(Rs, -Rs,  Rs);
  // Left Face
  glNormal3f(1.0, 0.0, 0.0);
   glVertex3f(-Rs, -Rs, -Rs);
   glVertex3f(-Rs, -Rs,  Rs);
   glVertex3f(-Rs, Rs,  Rs);
   glVertex3f(-Rs, Rs, -Rs);
  glEnd();
end;

procedure draw3dBar(x,y,z:single);     //  工字钢梁
const
  BFB_MatClr : Array[1..4] of glFloat = (0.7, 0.2, 0.1, 0.0);
  BFB_SpeClr : Array[1..4] of glFloat = (0.8, 0.3, 0.2, 0.0);
  BFB_AmbClr : Array[1..4] of glFloat = (0.2, 0.0, 0.2, 0.0);
  BYY_MatClr : Array[1..4] of glFloat = (0.7, 0.7, 0.1, 0.0);
  BYY_SpeClr : Array[1..4] of glFloat = (0.8, 0.8, 0.2, 0.0);
  BYY_AmbClr : Array[1..4] of glFloat = (0.2, 0.2, 0.0, 0.0);
var
  dy,dz: single;
begin
  dy:= 0.01; dz:=0.02;
  glBegin(GL_QUADS);
  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, @BFB_AmbClr);
  glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, @BFB_MatClr);
  glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, @BFB_SpeClr);
  // To Face
  glNormal3f(0.0, -1.0, 0.0);
   glVertex3f(-y/2+dy,  z/2, 0);
   glVertex3f(-y/2+dy,  z/2, x);
   glVertex3f( y/2-dy,  z/2, x);
   glVertex3f( y/2-dy,  z/2, 0);
  // Bt Face
  glNormal3f(0.0, 1.0, 0.0);
   glVertex3f( -y/2+dy, z/2-dz, 0);
   glVertex3f( -y/2+dy, z/2-dz, x);
   glVertex3f(  y/2-dy, z/2-dz, x);
   glVertex3f(  y/2-dy, z/2-dz, 0);

 glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, @BYY_AmbClr);
 glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, @BYY_MatClr);
 glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, @BYY_SpeClr);
  // 上翼缘
  glNormal3f(-1.0, 0.0, 0.0);
   glVertex3f( y/2, -z/2, 0);
   glVertex3f( y/2,  z/2, 0);
   glVertex3f( y/2,  z/2, x);
   glVertex3f( y/2, -z/2, x);
  glNormal3f(1.0, 0.0, 0.0);
   glVertex3f(y/2-dy, -z/2, 0);
   glVertex3f(y/2-dy, -z/2, x);
   glVertex3f(y/2-dy,  z/2, x);
   glVertex3f(y/2-dy,  z/2, 0);
    // To Face
  glNormal3f(0.0, -1.0, 0.0);
   glVertex3f(y/2-dy,  z/2, 0);
   glVertex3f(y/2-dy,  z/2, x);
   glVertex3f(y/2,  z/2, x);
   glVertex3f(y/2,  z/2, 0);
  // Bt Face
  glNormal3f(0.0, 1.0, 0.0);
   glVertex3f(y/2-dy, -z/2, 0);
   glVertex3f(y/2-dy, -z/2, x);
   glVertex3f(y/2, -z/2, x);
   glVertex3f(y/2, -z/2, 0);
 // 下翼缘
  glNormal3f(-1.0, 0.0, 0.0);
   glVertex3f(-y/2+dy, -z/2, 0);
   glVertex3f(-y/2+dy,  z/2, 0);
   glVertex3f(-y/2+dy,  z/2, x);
   glVertex3f(-y/2+dy, -z/2, x);
  // L Face
  glNormal3f(1.0, 0.0, 0.0);
   glVertex3f(-y/2, -z/2, 0);
   glVertex3f(-y/2, -z/2, x);
   glVertex3f(-y/2,  z/2, x);
   glVertex3f(-y/2,  z/2, 0);
  glNormal3f(0.0, -1.0, 0.0);
   glVertex3f(-y/2+dy,  z/2, 0);
   glVertex3f(-y/2+dy,  z/2, x);
   glVertex3f(-y/2,  z/2, x);
   glVertex3f(-y/2,  z/2, 0);
  // Bt Face
  glNormal3f(0.0, 1.0, 0.0);
   glVertex3f(-y/2+dy, -z/2, 0);
   glVertex3f(-y/2+dy, -z/2, x);
   glVertex3f(-y/2, -z/2, x);
   glVertex3f(-y/2, -z/2, 0);
  // Right face
  {glNormal3f(-1.0, 0.0, 0.0);
   glVertex3f(x, -Rs, -Rs);
   glVertex3f(x, Rs, -Rs);
   glVertex3f(x, Rs,  Rs);
   glVertex3f(x, -Rs,  Rs);
  // Left Face
  glNormal3f(1.0, 0.0, 0.0);
   glVertex3f(-Rs, -Rs, -Rs);
   glVertex3f(-Rs, -Rs,  Rs);
   glVertex3f(-Rs, Rs,  Rs);
   glVertex3f(-Rs, Rs, -Rs); }
  glEnd();
end;
procedure myDraw(ss: p_Tspg; sc, ax,ay,az,bax,bay: single; flag:byte);
const
  PI = 3.14159265359;
  coef_sc = 80;
  ND_MatClr : Array[1..4] of glFloat = (0.15, 0.8, 0.8, 0.0);
  ND_SpeClr : Array[1..4] of glFloat = (0.2, 0.9, 0.9, 0.0);
  ND_AmbClr : Array[1..4] of glFloat = (0.0, 0.3, 0.3, 0.0);

  // matShin : glFloat = 10;

var
   ang1, ang2, dx, dy, dz, len : glFloat;
   i, j, link_n : integer;
   Rx:single;
begin

glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
glEnable(GL_NORMALIZE);
glShadeModel(GL_SMOOTH);
// glCullFace(GL_FRONT);
glLoadIdentity;

glTranslatef(0.8*bax/coef_sc, bay/coef_sc, -15.0);

glRotatef(ax*180/PI, 1.0, 0.0, 0.0);
glRotatef(ay*180/PI, 0.0, 1.0, 0.0);
glRotatef(az*180/PI, 0.0, 0.0, 0.1);

// glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, @SpeColor);
// glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, @matShin);
// begin to draw
glscalef(sc/coef_sc, sc/coef_sc, 1.25*sc/coef_sc);    // 比例

// glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP);
// glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP);
// gluQuadricDrawStyle(MyQuadratic,GLU_LINE);
Rx:=0.08;

for j:= 1 to ss^.np do
  begin
  if ((flag = 0 ) or ((flag = 1)and(ss^.node[j].sel = 1))) then
    begin
     glPushMatrix();
     glTranslatef(ss^.node[j].x-ss^.midx, ss^.node[j].y-ss^.midy, ss^.node[j].z-ss^.midz);
     // gluSphere(MyQuadratic,0.1,24,24);
     glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, @ND_AmbClr);
     glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, @ND_MatClr);
     glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, @ND_SpeClr);
     drawCube(Rx);

     for i:=1 to ss^.node[j].linknodes.Count do
      begin
       link_n:= integer(ss^.node[j].linknodes.Items[i-1]^);
       if (flag = 0 ) or((flag = 1)and(ss^.node[link_n].sel = 1)) then
         if link_n > j then
          begin
            dx:= ss^.node[link_n].x - ss^.node[j].x;
            dy:= ss^.node[link_n].y - ss^.node[j].y;
            dz:= ss^.node[link_n].z - ss^.node[j].z;

            ang1:= -180*arctan2(dy,sqrt(dz*dz+dx*dx))/PI;
            ang2:= 180*arctan2(dx,dz)/PI;

            glPushMatrix();
            glRotatef(ang2,0.0,1.0,0.0);   //  沿y轴旋转
            glRotatef(ang1,1.0,0.0,0.0);   //  沿x轴旋转
            len := sqrt(dx*dx+dy*dy+dz*dz);
            // gluCylinder(MyQuadratic,0.04,0.04,len,24,24);
            draw3dBar(len,0.08,0.05);
            glPopMatrix();
           end;
       end;
      glPopMatrix();
    end;
  end;
SwapBuffers(wglGetCurrentDC);

end;

end.
