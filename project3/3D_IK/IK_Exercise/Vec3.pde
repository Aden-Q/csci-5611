///////////////////
// Vec3D Library
///////////////////

public class Vec3{
public float x, y, z;

    public Vec3(float x, float y, float z){
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public String toString(){
        return "(" + x + "," + y + "," + z + ")";
    }

    public float length(){
        return sqrt(x*x+y*y+z*z);
    }

    public float lengthSqr() {
        return x*x+y*y+z*z;
    }

    public Vec3 plus(Vec3 rhs){
        return new Vec3(x+rhs.x, y+rhs.y, z+rhs.z);
    }

    public void add(Vec3 rhs){
        x += rhs.x;
        y += rhs.y;
        z += rhs.z;
    }

    public void add(Vec2 rhs) {
        x+=rhs.x;
        z+=rhs.y;
    }

    public Vec3 minus(Vec3 rhs){
        return new Vec3(x-rhs.x, y-rhs.y, z-rhs.z);
    }

    public void subtract(Vec3 rhs){
        x -= rhs.x;
        y -= rhs.y;
        z -= rhs.z;
    }

    public Vec3 times(float rhs){
        return new Vec3(x*rhs, y*rhs, z*rhs);
    }

    public void mul(float rhs){
        x *= rhs;
        y *= rhs;
        z *= rhs;
    }
    
    public float distanceTo(Vec3 rhs){
        float dx = rhs.x - x;
        float dy = rhs.y - y;
        float dz = rhs.z - z;
        return sqrt(dx*dx + dy*dy + dz*dz);
    }
    
    public void normalize(){
        float magnitude = sqrt(x*x + y*y + z*z);
        x /= magnitude;
        y /= magnitude;
        z /= magnitude;
    }
    
   public Vec3 normalized(){
        float magnitude = sqrt(x*x + y*y + z*z);
        return new Vec3(x/magnitude, y/magnitude, z/magnitude);
   }
   
   public Vec3 clone(){
     return new Vec3(x,y,z);
   }
    
}

float dot3d(Vec3 a, Vec3 b){
    return a.x*b.x + a.y*b.y + a.z*b.z;
}

float cross3d(Vec3 a, Vec3 b) {
  float newx = a.y*b.z - a.z*b.y;
  float newy = a.z*b.x - a.x*b.z;
  float newz = a.x*b.y - a.y*b.x;
  return newz;
  //return new Vec3(newx, newy, newz);
}
